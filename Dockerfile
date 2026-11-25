FROM eclipse-temurin:21
WORKDIR /app
COPY ./build/libs/hello-docker-0.0.1-SNAPSHOT.jar ./app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]