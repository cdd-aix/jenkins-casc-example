# Best practice is a specific release tag
FROM jenkins/jenkins:lts-alpine
ENV CASC_JENKINS_CONFIG=${JENKINS_HOME}/jenkins.yaml\
    JENKINS_LOCATION_URL=${JENKINS_LOCATION_URL:-http://localhost:8080/}
# Best practice is a specific plugin version
RUN /usr/local/bin/install-plugins.sh\
    configuration-as-code\
    script-security\
    swarm
COPY jenkins.yaml ${JENKINS_HOME}/
