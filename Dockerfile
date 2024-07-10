# Dockerfile for Jenkins based on Alpine
FROM alpine

# Adding a file to root
ADD file / 

# Update package index
RUN /bin/sh -c "apk update"

# Install curl
RUN /bin/sh -c "apk add --no-cache curl"

# Set environment variables
ENV LANG=C.UTF-8
ARG TARGETARCH=amd64
ARG COMMIT_SHA=9fba54713675c711138675b4aaaff6268c14d31a
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref
ENV JENKINS_HOME=$JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT=$agent_port
ENV REF=$REF

# Add Jenkins volume
VOLUME $JENKINS_HOME

# Install Jenkins and plugins
ARG JENKINS_VERSION=2.467
ENV JENKINS_VERSION=$JENKINS_VERSION
ARG JENKINS_SHA=965fdbf11e1735f18ee143ebb5b12a8c3055a725385311f5fd4c336c064bc346
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.467/jenkins-war-2.467.war
RUN /bin/sh -c "curl -fsSL $JENKINS_URL -o /usr/share/jenkins/jenkins.war"

# Jenkins environment variables
ENV JENKINS_UC=https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals

# Install Jenkins plugin manager
ARG PLUGIN_CLI_VERSION=2.13.0
ARG PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.13.0/jenkins-plugin-manager-2.13.0.jar
RUN /bin/sh -c "curl -fsSL $PLUGIN_CLI_URL -o /usr/share/jenkins/jenkins-plugin-manager.jar"

# Expose ports
EXPOSE 8080
EXPOSE 50000

# Set Jenkins home
ENV COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

# Set Java home and path
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Copy Java runtime and Jenkins support scripts
COPY /javaruntime /opt/java/openjdk
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY jenkins-plugin-cli.sh /bin/jenkins-plugin-cli

# Set entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# Set Docker image labels
LABEL org.opencontainers.image.vendor="Jenkins project" \
      org.opencontainers.image.title="Official Jenkins"
