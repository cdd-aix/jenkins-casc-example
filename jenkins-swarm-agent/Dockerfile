# Mooched from https://github.com/carlossg/jenkins-swarm-slave-docker
FROM openjdk:8-jre-alpine3.9
ENTRYPOINT ["/jenkins-swarm.sh"]
RUN adduser -h /home/jenkins-agent -g "Jenkins Swarm Agent User" jenkins-agent -D
VOLUME /home/jenkins-agent
RUN apk add --no-cache bash=4.4.19-r1
COPY swarm-client-*.jar jenkins-swarm.sh /
RUN ln -s /swarm-client-*.jar /swarm-client.jar
USER jenkins-agent
