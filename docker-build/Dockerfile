# Docker image for building ffmpeg

FROM amazonlinux:1

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget yasm zlib

LABEL maintainer="Brian Enigma <brian@netninja.com>"
LABEL name="ffmpeg-build"

