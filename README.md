# hadoop_docker


#how to build docker
docker build -t hadoop .

docker rm -f hadoop-master hadoop-slave
docker run -itd  -p 50070:50070 -p 8088:8088 -p 50001:22 --name hadoop-master --hostname hadoop-master hadoop
docker run -itd  -p 50002:22 --name hadoop-slave --hostname hadoop-slave hadoop

docker exec -it hadoop-master bash

docker rm -f hadoop-master hadoop-slave
