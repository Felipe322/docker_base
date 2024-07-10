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
ENV JENKINS_VERSION=2.467
ENV JENKINS_SHA=965fdbf11e1735f18ee143ebb5b12a8c3055a725385311f5fd4c336c064bc346

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
