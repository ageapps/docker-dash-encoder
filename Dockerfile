FROM ubuntu:16.04

MAINTAINER age.apps.dev@gmail.com

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y subversion gcc software-properties-common make libgcrypt11-dev zlib1g-dev 

WORKDIR /media

RUN \
        svn co https://svn.code.sf.net/p/gpac/code/trunk/gpac gpac && \
        cd gpac && \
        chmod +x configure && \
        ./configure && \
        make && \ 
        make install && \
        cp bin/gcc/libgpac.so /usr/lib

RUN add-apt-repository ppa:jonathonf/ffmpeg-3
RUN apt-get update -y
RUN apt install ffmpeg libav-tools x264 x265 -y

COPY convert.sh .


