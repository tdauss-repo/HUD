#!/bin/bash

sudo apt update

sudo apt install -y \
    build-essential \
    libcurl4-openssl-dev \
    libpcap-dev \
    libx11-dev \
    ninja-build \
    protobuf-compiler \
    libprotobuf-dev \
    libprotoc-dev \
	libjsoncpp-dev \
	pkg-config