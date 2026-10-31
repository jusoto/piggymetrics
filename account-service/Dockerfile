# FROM java:8-jre
# MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

# ADD ./target/account-service.jar /app/
# CMD ["java", "-Xmx200m", "-jar", "/app/account-service.jar"]

# EXPOSE 6000

# FROM ubuntu:22.04
# LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"
# RUN apt-get update && apt-get install -y openjdk-8-jdk apt-transport-https gnupg2 curl lsb-release
# ADD https://github.com/envoyproxy/envoy/releases/download/v1.29.3/envoy-1.29.3-linux-x86_64 /usr/local/bin/envoy
# RUN chmod +x /usr/local/bin/envoy && \
#     mkdir /app
# COPY . /app
# WORKDIR /app
# VOLUME /tmp

# COPY ./target/account-service.jar /app/account-service.jar
# RUN groupadd -r appuser && useradd -r -g appuser appuser
# COPY ./envoy.yaml /etc/envoy/envoy.yaml
# COPY ./docker-entrypoint.sh /docker/entrypoint.sh

# RUN chmod 0444 /etc/envoy/envoy.yaml \
#  && chmod 0555 /docker/entrypoint.sh \
#  && chown -R appuser:appuser /app /etc/envoy /docker

# USER appuser
# ENV JAVA_OPTS="-Xmx200m"
# EXPOSE 6000
# ENTRYPOINT ["/docker/entrypoint.sh"]

# # ENV JAVA_OPTS="-Xmx200m"
# # EXPOSE 6000
# # ENTRYPOINT [ "sh", "-c", "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml & java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/account-service.jar" ]

# Run the Spring Boot JAR on a slim, reliable JRE
FROM eclipse-temurin:8-jre-jammy

# # Install curl for fetching Envoy, add a nonroot user
# RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
#     && rm -rf /var/lib/apt/lists/* \
#     && useradd -u 10001 -r -s /usr/sbin/nologin appuser \
#     && mkdir -p /app /etc/envoy /docker \
#     && chown -R appuser:appuser /app /etc/envoy /docker

# # --- Envoy (pin version + verify) ---
# ARG ENVOY_VERSION=1.29.3
# ARG ENVOY_URL=https://github.com/envoyproxy/envoy/releases/download/v${ENVOY_VERSION}/envoy-${ENVOY_VERSION}-linux-x86_64
# ADD ${ENVOY_URL} /usr/local/bin/envoy
# # TODO: add a SHA256 check here for the binary you download
# RUN chmod +x /usr/local/bin/envoy

# # --- App JAR + Envoy config + entrypoint ---
# # Copy only the fat jar, not the whole context
# COPY ./target/account-service.jar /app/account-service.jar
# # This envoy.yaml must have concrete ports: listen 6000 -> 127.0.0.1:6001
# COPY ./envoy.yaml /etc/envoy/envoy.yaml
# COPY ./docker-entrypoint.sh /docker/entrypoint.sh

# RUN chmod 0444 /etc/envoy/envoy.yaml \
#     && chmod 0555 /docker/entrypoint.sh \
#     && chown -R appuser:appuser /app /etc/envoy /docker

# USER appuser
# ENV JAVA_OPTS="-Xmx200m"
# EXPOSE 6000 6001 19000
# ENTRYPOINT ["/docker/entrypoint.sh"]


ADD ./target/account-service.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/account-service.jar"]

EXPOSE 6000