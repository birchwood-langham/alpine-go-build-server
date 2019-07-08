#!/usr/bin/env bash

current_version=`docker run -t --rm birchwoodlangham/alpine-go-build-server:latest go version | cut -d ' ' -f3`
docker rmi -f birchwoodlangham/alpine-go-build-server:${current_version}
docker rmi -f birchwoodlangham/alpine-go-build-server:latest

docker build -t birchwoodlangham/alpine-go-build-server:latest .
next_version=`docker run -t --rm birchwoodlangham/alpine-go-build-server:latest go version | cut -d ' ' -f3`
docker tag birchwoodlangham/alpine-go-build-server:latest birchwoodlangham/alpine-go-build-server:${next_version}
