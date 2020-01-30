FROM alpine

ARG FFMPEG_VERSION=4.2.2
ARG PREFIX=/opt/ffmpeg
ARG LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG MAKEFLAGS="-j4"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk update \
  && apk upgrade --no-cache \
  && apk add --no-cache --update \
         build-base \
         coreutils \
         freetype-dev \
         gcc \
         lame-dev \
         libogg-dev \
         libass \
         libass-dev \
         libvpx-dev \
         libvorbis-dev \
         libwebp-dev \
         libtheora-dev \
         opus-dev \
         pkgconf \
         pkgconfig \
         rtmpdump-dev \
         wget \
         x264-dev \
         x265-dev \
         openssl-dev \
         yasm

# Get ffmpeg source.
RUN cd /tmp/ && \
  wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Compile ffmpeg.
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  ./configure \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
  --enable-libmp3lame \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libopus \
  --enable-libass \
  --enable-libwebp \
  --enable-librtmp \
  --enable-postproc \
  --enable-avresample \
  --enable-libfreetype \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --enable-openssl \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" && \
  make && make install && make distclean && \
  rm -rf /var/cache/apk/* /tmp/*
