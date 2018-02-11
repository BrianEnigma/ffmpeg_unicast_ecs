BUILD_CONTAINER_NAME=ffmpeg-build
FFMPEG_CONTAINER_NAME=ffmpeg-unicast
VIDEO_FILE=video.ts

HERE=`pwd`

include config.mk

all: package

# Create a container for the build toolchain.
toolchain:
	if [ 0 == `docker image ls | grep $(BUILD_CONTAINER_NAME) | wc -l` ]; then \
		cd docker-build ; docker build -t $(BUILD_CONTAINER_NAME) . ; \
	fi

# Compile ffmpeg using the build toolchain container. Do all of this in the './build/ folder.
binary: toolchain
	# If there was a previous runtime container, remove it.
	if [ 1 == `docker container ls -a | grep $(BUILD_CONTAINER_NAME) | wc -l` ]; then \
		docker container rm $(BUILD_CONTAINER_NAME) ; \
	fi
	# Copy the build script into a shared folder.
	mkdir -p build
	cp scripts/static_ffmpeg_build.sh ./build/
	# User the container to run the build script.
	docker run --name $(BUILD_CONTAINER_NAME) --rm -v "$(HERE)/build:/build" -i $(BUILD_CONTAINER_NAME) /bin/bash -c 'cd build ; ./static_ffmpeg_build.sh' ; \

interactive-dev:
	docker run --name $(BUILD_CONTAINER_NAME) --rm -v "$(HERE)/build:/build" -t -i $(BUILD_CONTAINER_NAME) /bin/bash

package: binary
	cp ./build/bin/ffmpeg ./docker-package/
	cp ./video.ts ./docker-package/
	cp ./playout.sh ./docker-package/
	cd docker-package ; docker build -t $(FFMPEG_CONTAINER_NAME) .

interactive-run:
	docker run --name $(FFMPEG_CONTAINER_NAME) --rm -v "$(HERE)/build:/build" -t -i $(FFMPEG_CONTAINER_NAME) /bin/bash

test:
	docker run --name $(FFMPEG_CONTAINER_NAME) --rm -v "$(HERE)/build:/build" -t -i $(FFMPEG_CONTAINER_NAME) -e DEST_IP=10.0.1.15 -e DEST_PORT=5001

push:
	aws --profile $(AWS_PROFILE) ecr get-login --no-include-email --region $(AWS_REGION) > ecr_login.sh
	sh ./ecr_login.sh
	rm -f ./ecr_login.sh
	docker tag $(FFMPEG_CONTAINER_NAME):latest $(ECR_URI):latest
	docker push $(ECR_URI):latest

clean:
	rm -rf build ecr_login.sh
	rm -f docker-package/ffmpeg docker-package/$(VIDEO_FILE) docker-package/playout.sh

