# # FROM java:8-jre
# # MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

# # ADD ./target/gateway.jar /app/
# # CMD ["java", "-Xmx200m", "-jar", "/app/gateway.jar"]

# # EXPOSE 4000
# # FROM ubuntu:22.04
# # LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"
# # RUN apt-get update && apt-get install -y openjdk-8-jdk apt-transport-https gnupg2 curl lsb-release
# # ADD https://github.com/envoyproxy/envoy/releases/download/v1.29.3/envoy-1.29.3-linux-x86_64 /usr/local/bin/envoy
# # RUN chmod +x /usr/local/bin/envoy && \
# #     mkdir /app
# # COPY . /app
# # WORKDIR /app
# # VOLUME /tmp
# # COPY ./target/gateway.jar /app/
# # COPY envoy.yaml /etc/envoy/envoy.yaml
# # RUN chmod go+r /etc/envoy/envoy.yaml
# # ENV JAVA_OPTS="-Xmx200m"
# # EXPOSE 4000 4001 19000
# # ENTRYPOINT [ "sh", "-c", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/gateway.jar" ]

# FROM ubuntu:22.04
# LABEL maintainer="Juan P. Sotomayor <jsoto128@fiu.edu>"

# # Base deps (use JRE if you can; Java 8 JDK works but is heavier)
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends openjdk-8-jre-headless curl ca-certificates tini \
#     && rm -rf /var/lib/apt/lists/*

# # Envoy (pin version)
# ADD https://github.com/envoyproxy/envoy/releases/download/v1.29.3/envoy-1.29.3-linux-x86_64 /usr/local/bin/envoy
# RUN chmod +x /usr/local/bin/envoy

# # App directories
# WORKDIR /app
# RUN mkdir -p /etc/envoy /docker

# # Copy ONLY what you need
# COPY ./target/gateway.jar /app/gateway.jar
# COPY envoy.yaml /etc/envoy/envoy.yaml
# COPY docker-entrypoint.sh /docker/entrypoint.sh

# # Permissions
# RUN chmod 0444 /etc/envoy/envoy.yaml \
#     && chmod 0555 /docker/entrypoint.sh

# # App memory and ports
# ENV JAVA_OPTS="-Xmx200m"
# EXPOSE 4000
# # (Do NOT expose 4001; it’s internal-only)

# # Use tini to handle signals/defuncts; entrypoint supervises both processes
# ENTRYPOINT ["/usr/bin/tini", "--", "/docker/entrypoint.sh"]
# # ENTRYPOINT [ "sh", "-c", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & exec java $JAVA_OPTS -Dserver.port=4001 -Deureka.instance.non-secure-port=4000 -Djava.security.egd=file:/dev/./urandom -jar /app/gateway.jar" ]
# # ENTRYPOINT ["/usr/bin/tini","--","/bin/sh","-lc", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & \
# #     exec java $JAVA_OPTS \
# #     -Dserver.port=4001 \
# #     -Deureka.instance.non-secure-port=4000 \
# #     -Djava.security.egd=file:/dev/./urandom \
# #     -jar /app/gateway.jar" ]

# gateway/Dockerfile
FROM eclipse-temurin:8-jre-jammy

WORKDIR /app
COPY ./target/gateway.jar /app/gateway.jar

# App runs on 4001 (internal); Envoy will listen on 4000 in the *shared* netns
EXPOSE 4001

ENV JAVA_OPTS="-Xmx200m"

ENTRYPOINT ["sh","-lc","exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/gateway.jar"]
