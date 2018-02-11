# Docker image for an ffmpeg unicast broadcaster

FROM amazonlinux:1

COPY ffmpeg /usr/bin/
COPY playout.sh /usr/bin/
COPY video.ts /
ENV DEST_IP=10.0.1.15
ENV DEST_PORT=5001
ENTRYPOINT exec /usr/bin/playout.sh

LABEL maintainer="Brian Enigma <brian@netninja.com>"
LABEL name="ffmpeg-unicast"

