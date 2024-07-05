# Stage 1: Build
FROM maven:latest AS build

WORKDIR /app

# Copy the pom.xml and download dependencies
# COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the application
# COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Run
FROM openjdk:latest

WORKDIR /app

# Copy the JAR file from the build stage
#COPY --from=build /app/target/*.jar app.jar

# Create a user and group to run the application
#RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
