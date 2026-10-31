# FROM java:8-jre
# MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

# ADD ./target/monitoring.jar /app/
# CMD ["java", "-Xmx200m", "-jar", "/app/monitoring.jar"]

# EXPOSE 8080

FROM eclipse-temurin:8-jre-jammy
LABEL MAINTAINER="Juan P. Sotomayor jsoto128@fiu.edu"

ADD ./target/monitoring.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/monitoring.jar"]

EXPOSE 8080