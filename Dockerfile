FROM openjdk:11-jre-slim

COPY target/*.jar /app.jar

EXPOSE 5000

ENTRYPOINT ["java", "-jar", "/app.jar"]
