#!/usr/bin/env bash

docker rmi -f birchwoodlangham/alpine-go-build-server:latest

docker build -t birchwoodlangham/alpine-go-build-server:latest .
