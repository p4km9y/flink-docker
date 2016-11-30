FROM java:openjdk-8
MAINTAINER p4km9y

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_CONF_DIR /opt/hadoop-config

RUN current="http://www.apache.org/dist/flink/flink-1.1.3" && \
    ref=$(wget -qO - ${current} | grep -v src\\. | grep -v doc | sed -n 's/.*href="\(flink.*\.tgz\)".*/\1/p' | tail -1) && \
    wget -O - ${current}/${ref} | gzip -dc | tar x -C /opt/ -f - && \
    dir=`ls /opt | grep flink` && \
    ln -s /opt/${dir} /opt/flink && \
    /bin/echo -e "\nstate.backend: filesystem\nstate.backend.fs.checkpointdir: hdfs://hadoop:9000/flink/checkpoints" >> /opt/flink/conf/flink-conf.yaml

RUN adduser --no-create-home --home /opt/flink --system --disabled-password --disabled-login flink && \
    chown -R flink:root /opt/flink/

USER flink

EXPOSE 8081

CMD /opt/flink/bin/yarn-session.sh -n 2 -s 2
