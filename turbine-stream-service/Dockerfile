# FROM java:8-jre
# MAINTAINER Chi Dov <d.chiproeng@gmail.com>

# ADD ./target/turbine-stream-service.jar /app/
# CMD ["java", "-Xmx200m", "-jar", "/app/turbine-stream-service.jar"]

# EXPOSE 8989

FROM eclipse-temurin:8-jre-jammy
LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"

ADD ./target/turbine-stream-service.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/turbine-stream-service.jar"]

EXPOSE 8989