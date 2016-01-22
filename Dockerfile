FROM google/debian:wheezy

RUN apt-get update && apt-get install -y wget

ENV INFLUXDB_VERSION 0.9.3
RUN wget http://influxdb.s3.amazonaws.com/influxdb_0.9.3_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -fr influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

ADD config.toml /opt/influxdb/shared/config.toml

RUN echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf
RUN echo "influxdb riak hard nofile unlimited" >> /etc/security/limits.conf

#      admin    http    meta
EXPOSE 83       86      88

VOLUME ["/data"]
CMD ["/usr/bin/influxdb", "--config=/opt/influxdb/shared/config.toml", "--pidfile=/tmp/influxdb.pid"]
