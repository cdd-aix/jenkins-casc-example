# Mooched from https://github.com/carlossg/jenkins-swarm-slave-docker
FROM openjdk:8-jre-alpine3.9
ENTRYPOINT ["/usr/local/bin/jenkins-swarm.sh"]
RUN adduser -h /home/jenkins-agent -g "Jenkins Swarm Agent User" jenkins-agent -D
RUN apk add --no-cache bash=4.4.19-r1
ARG JENKINS_SWARM_VERSION=${JENKINS_SWARM_VERSION:-3.17}
ENV JENKINS_SWARM_VERSION ${JENKINS_SWARM_VERSION}
ADD --chown=jenkins-agent https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar /swarm-client-$JENKINS_SWARM_VERSION.jar
COPY jenkins-swarm.sh /usr/local/bin/jenkins-swarm.sh
USER jenkins-agent
VOLUME /home/jenkins-agent
