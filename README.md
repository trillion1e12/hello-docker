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

Push `latest` too

```bash
docker tag trillion1e12/hello-docker:1.0 trillion1e12/hello-docker:latest
docker push trillion1e12/hello-docker:latest
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

### `2.0`

Compile the JAR during image building

```Dockerfile
FROM eclipse-temurin:21
WORKDIR /app
COPY . .
RUN ./gradlew build
ENTRYPOINT [ "java", "-jar", "build/libs/hello-docker-0.0.1-SNAPSHOT.jar" ]
```

## Using Kubernetes

Create the pod:

```bash
kubectl run hello-pod --image=trillion1e12/hello-docker
```

Create a NodePort service for the pod:

```bash
kubectl expose pod hello-pod --port=8080 --type=NodePort --name=hello-service
```

(Minikube in WSL2) Expose the service for external access localhost URL

```bash
minikube service hello-service --url
```

## References

- https://docs.docker.com/learn/paths/build-and-share-your-own-images/
- https://spring.io/guides/gs/spring-boot-docker
- https://docs.docker.com/build/concepts/dockerfile/
