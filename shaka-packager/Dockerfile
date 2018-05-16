FROM google/shaka-packager

MAINTAINER Adrián García Espinosa "age.apps.dev@gmail.com"

# Update and install dependencies

RUN \
      apt-get update -y && \ 
      apt-get upgrade -y && \
      apt-get install -y software-properties-common


WORKDIR /encoder

# Install ffmmpeg with x264 encoder

RUN \
      add-apt-repository -y ppa:mc3man/trusty-media && \
      apt-get update -y && \
      apt install ffmpeg libav-tools x264 -y

WORKDIR shaka_packager

COPY convert-shaka.sh .


