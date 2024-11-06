FROM ubuntu:20.04
   
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

ARG flutter_version
RUN git clone https://github.com/flutter/flutter.git -b ${flutter_version}
ENV PATH "$PATH:/home/developer/flutter/bin"

RUN flutter doctor