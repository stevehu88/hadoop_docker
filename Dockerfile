FROM ubuntu:14.04
MAINTAINER Steve <stevehu88@126.com>
ENV http_proxy 'http://proxy.pal.sap.corp:8080'
ENV https_proxy 'http://proxy.pal.sap.corp:8080'
ENV ftp_proxy 'http://proxy.pal.sap.corp:8080'

WORKDIR /root



# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y  openssh-server software-properties-common

RUN add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk

# install hadoop 2.7.2
COPY hadoop-3.0.0-alpha1.tar.gz .
RUN tar zxvf hadoop-3.0.0-alpha1.tar.gz && \
	mv hadoop-3.0.0-alpha1 /usr/local/hadoop && \
	rm hadoop-3.0.0-alpha1.tar.gz


# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


RUN mkdir -p ~/hdfs/namenode && \
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/sshd_config  /etc/ssh && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh


ADD local_id_rsa.pub  /tmp/mainhost_id_rsa.pub
RUN  cat /tmp/mainhost_id_rsa.pub >> ~/.ssh/authorized_keys


# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
