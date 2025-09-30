# Multi-stage build: compile with Maven, then run on Java 11
FROM maven:3.9.8-eclipse-temurin-11 AS build
WORKDIR /app

# Copy pom first to leverage Docker layer caching for dependencies
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copy the source code and build the project
COPY src ./src
RUN mvn -B -DskipTests package \
 && mvn -B dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/libs

# Use Java 11 JRE for compatibility
FROM eclipse-temurin:11-jre
WORKDIR /app

# Update CA certificates for SSL/TLS support
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Copy the application JAR and its runtime dependencies
COPY --from=build /app/target/mongo-connection-test-1.0-SNAPSHOT.jar app.jar
COPY --from=build /app/target/libs ./libs

# The application expects MONGODB_URI to be provided at runtime
ENV MONGODB_URI=""

# Simple entrypoint with SSL workarounds for Java 11 on ARM
ENTRYPOINT ["java", "-Djdk.tls.client.protocols=TLSv1.2", "-Djavax.net.ssl.cipherSuites=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256", "-cp", "/app/app.jar:/app/libs/*", "com.example.MongoTest"]
