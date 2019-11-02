# Best practice is a specific release tag
FROM jenkins/jenkins:lts-alpine
ENV CASC_JENKINS_CONFIG ${JENKINS_HOME}/jenkins.yaml
# Best practice is a specific plugin version
RUN /usr/local/bin/install-plugins.sh configuration-as-code
COPY jenkins.yaml ${JENKINS_HOME}/
