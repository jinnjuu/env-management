FROM openjdk:17.0.1-jdk-slim as build
WORKDIR /app
COPY . .
RUN ./gradlew clean build --no-build-cache -x test


FROM openjdk:17.0.1-jdk-slim
ENV TZ Asia/Seoul

RUN adduser --system --uid 1001 --group spring
USER spring

WORKDIR /app
COPY --from=build /app/build/libs/env-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080:8080
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]