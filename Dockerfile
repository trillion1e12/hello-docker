FROM eclipse-temurin:21
WORKDIR /app
COPY . .
RUN ./gradlew build
ENTRYPOINT [ "java", "-jar", "build/libs/hello-docker-0.0.1-SNAPSHOT.jar" ]