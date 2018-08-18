#!/bin/bash
docker kill $1
docker rm $1
docker rmi my-nginx:0.1
docker build -t my-nginx:0.1 .
docker run -dt -p 80:80 my-nginx:0.1
docker ps
