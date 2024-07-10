# Use Alpine Linux as base image
FROM alpine:latest

# Install Jenkins and dependencies
RUN apk update && \
    apk add openjdk11-jdk && \
    wget -q -O /tmp/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war && \
    mkdir -p /opt/jenkins && \
    mv /tmp/jenkins.war /opt/jenkins/jenkins.war

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins when container launches
CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
