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

Tag the image (`1.0` is version, replace them when upgrading)

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
docker run -p 8080:8080 -d trillion1e12/hello-docker
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

### `3.0`

Multi-stage build

```Dockerfile
FROM eclipse-temurin:21-jdk AS stage-1
WORKDIR /app
COPY . .
RUN ./gradlew build

FROM eclipse-temurin:21-jre AS stage-2
WORKDIR /app
COPY --from=stage-1 /app/build/libs/hello-docker-0.0.1-SNAPSHOT.jar ./app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]
```

### `4.0`

Stop hard coding JAR filename

```Dockerfile
FROM eclipse-temurin:21-jdk AS stage-1
WORKDIR /app
COPY . .
RUN ./gradlew bootJar

FROM eclipse-temurin:21-jre AS stage-2
WORKDIR /app
COPY --from=stage-1 /app/build/libs/*.jar ./app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]
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

## Pushing to AWS ECR

Install AWS CLI, login, create ECR private repository (through console), then push

- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sign-in.html

## References

- https://docs.docker.com/learn/paths/build-and-share-your-own-images/
- https://spring.io/guides/gs/spring-boot-docker
- https://docs.docker.com/build/concepts/dockerfile/
