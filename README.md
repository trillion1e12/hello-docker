# Containerize a Spring Boot Gradle REST API with Dockerfile

How it's run normally:

```bash
./gradlew build
java -jar build/libs/hello-docker-0.0.1-SNAPSHOT.jar
```

Build the image from Dockerfile:

```bash
docker build . -t hello-docker
```

Tag the image (`1.0` is version, see list of versions at [Docker Hub](https://hub.docker.com/r/trillion1e12/hello-docker))

```bash
docker tag hello-docker trillion1e12/hello-docker:1.0
```

Push the image (login required)

```bash
docker push trillion1e12/hello-docker:1.0
```

Run the docker image:

```bash
docker run -p 8080:8080 -d trillion1e12/hello-docker:1.0
```

## Versions

### `1.0`

Require building the project with `./gradlew build` before building the image.

```Dockerfile
FROM eclipse-temurin:21
WORKDIR /app
COPY ./build/libs/hello-docker-0.0.1-SNAPSHOT.jar ./app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]
```

## References

- https://docs.docker.com/learn/paths/build-and-share-your-own-images/
- https://spring.io/guides/gs/spring-boot-docker
- https://docs.docker.com/build/concepts/dockerfile/
