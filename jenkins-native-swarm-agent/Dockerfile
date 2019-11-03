FROM alpine:3.9
ENTRYPOINT ["/jenkins-native-swarm.sh"]
RUN adduser -h /home/jenkins-agent -g "Jenkins Swarm Agent User" jenkins-image -D
VOLUME /home/jenkins-agent
RUN apk add --no-cache bash=4.4.19-r1 libc6-compat=1.1.20-r5
COPY swarm-client-* jenkins-native-swarm.sh /
RUN ln -s /swarm-client-* /swarm-client
