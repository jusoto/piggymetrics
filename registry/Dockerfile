# FROM java:8-jre
# MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

# ADD ./target/registry.jar /app/
# CMD ["java", "-Xmx200m", "-jar", "/app/registry.jar"]

# EXPOSE 8761

FROM eclipse-temurin:8-jre-jammy
LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"

WORKDIR /app
COPY ./target/registry.jar /app/registry.jar

EXPOSE 8761
ENV JAVA_OPTS="-Xmx200m"

ENTRYPOINT ["sh","-lc","exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/registry.jar"]
