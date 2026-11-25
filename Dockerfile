FROM eclipse-temurin:21-jdk AS stage-1
WORKDIR /app
COPY . .
RUN ./gradlew build

FROM eclipse-temurin:21-jre AS stage-2
WORKDIR /app
COPY --from=stage-1 /app/build/libs/hello-docker-0.0.1-SNAPSHOT.jar ./app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]