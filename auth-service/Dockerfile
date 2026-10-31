# FROM java:8-jre
# MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

# ADD ./target/auth-service.jar /app/
# CMD ["java", "-Xmx200m", "-jar", "/app/auth-service.jar"]

# EXPOSE 5000
FROM eclipse-temurin:8-jre-jammy
LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"
# RUN apt-get update && apt-get install -y openjdk-8-jdk apt-transport-https gnupg2 curl lsb-release
# ADD https://github.com/envoyproxy/envoy/releases/download/v1.29.3/envoy-1.29.3-linux-x86_64 /usr/local/bin/envoy
# RUN chmod +x /usr/local/bin/envoy && \
#     mkdir /app
# COPY . /app
# WORKDIR /app
# VOLUME /tmp
# COPY ./target/auth-service.jar /app/
# COPY envoy.yaml /etc/envoy/envoy.yaml
# RUN chmod go+r /etc/envoy/envoy.yaml
# ENV JAVA_OPTS="-Xmx200m"
# EXPOSE 5000 5001 19000
# ENTRYPOINT [ "sh", "-c", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/auth-service.jar" ]

ADD ./target/auth-service.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/auth-service.jar"]

EXPOSE 5000