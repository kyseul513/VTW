FROM openjdk:11-jdk
VOLUME /tmp
ARG JAR_FILE=./build/libs/vtw-0.0.1-SNAPSHOT.jar
COPY . .
ENTRYPOINT ["java", "-jar", "app.jar"]