# Docker image for an ffmpeg unicast broadcaster

FROM amazonlinux:1

COPY ffmpeg /usr/bin/
COPY playout.sh /usr/bin/
COPY video.ts /

LABEL maintainer="Brian Enigma <brian@netninja.com>"
LABEL name="ffmpeg-unicast"

