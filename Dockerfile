# Use the official Alpine image as the base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add openjdk17-jre wget git bash && \
    apk add --no-cache shadow && \
    rm -rf /var/cache/apk/*

# Define Jenkins environment variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_VERSION 2.414.1
ENV JENKINS_SHA 8e8d9b5b5b4f44e6bf6d71d78b3b1ec7c7bb10d13f77b54420f47a5a2d243fc7

# Create Jenkins user and group
RUN addgroup -S jenkins && adduser -S -G jenkins jenkins

# Create Jenkins home directory
RUN mkdir -p /usr/share/jenkins/ && \
    mkdir -p $JENKINS_HOME && \
    chown -R jenkins:jenkins $JENKINS_HOME

# Download and install Jenkins
RUN wget -q -O /usr/share/jenkins/jenkins.war http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

# Expose Jenkins ports
EXPOSE 8080
EXPOSE 50000

# Switch to Jenkins user
USER jenkins

# Set up entrypoint and command
ENTRYPOINT ["/usr/bin/java", "-jar", "/usr/share/jenkins/jenkins.war"]
