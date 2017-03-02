FROM java:openjdk-8
MAINTAINER p4km9y

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_CONF_DIR /opt/hadoop-config

ADD flink-1.3-SNAPSHOT /opt/flink

RUN /bin/echo -e "\nstate.backend: filesystem\nstate.backend.fs.checkpointdir: hdfs://hadoop-master:9000/flink/checkpoints" >> /opt/flink/conf/flink-conf.yaml

RUN adduser --no-create-home --home /opt/flink --system --disabled-password --disabled-login flink && \
    chown -R flink:root /opt/flink/

USER flink

EXPOSE 8081

CMD /opt/flink/bin/yarn-session.sh -n 2 -s 2
