# Description: Dockerfile for statistics-service with an Envoy sidecar (same layout as rideshare)
# Envoy listens on 7000 and forwards to the app on 7001; requests/responses are tapped to /var/log/envoy
FROM ubuntu:22.04
LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"
RUN apt-get update && apt-get install -y openjdk-8-jdk apt-transport-https gnupg2 curl lsb-release
ADD https://github.com/envoyproxy/envoy/releases/download/v1.29.3/envoy-1.29.3-linux-x86_64 /usr/local/bin/envoy
RUN chmod +x /usr/local/bin/envoy && \
    mkdir /app
WORKDIR /app
VOLUME /tmp
COPY ./target/statistics-service.jar /app/statistics-service.jar
COPY envoy.yaml /etc/envoy/envoy.yaml
RUN chmod go+r /etc/envoy/envoy.yaml
ENV JAVA_OPTS="-Xmx200m"
EXPOSE 7000 7001 9901
ENTRYPOINT [ "sh", "-c", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/statistics-service.jar" ]
