#!/bin/bash
docker build -t hadoop .
#clean existing docker containers
docker rm -f hadoop-master hadoop-slave1 hadoop-slave2
#clean network
docker network rm hadoop
#create network
docker network create --driver=bridge hadoop
#start hadoop master container
docker run -itd \
		   --net=hadoop \
		   -p 9000:9000 \
		   -p 9001:9001 \
           -p 19888:19888 \
           -p 8088:8088 \
           -p 9870:9870 \
           -p 50000:22  \
           --name hadoop-master \
           --hostname hadoop-master \
           hadoop  &> /dev/null

#start hadoop slave container

docker run -itd \
		   --net=hadoop \
		   -p 50001:22 \
		   --name hadoop-slave1 \
		   --hostname hadoop-slave1 \
		   hadoop  &> /dev/null


docker run -itd \
		   --net=hadoop \
		   -p 50002:22 \
		   --name hadoop-slave2 \
		   --hostname hadoop-slave2 \
		   hadoop  &> /dev/null


# get into hadoop master container
docker exec -it hadoop-master bash
