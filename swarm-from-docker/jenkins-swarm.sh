#!/bin/bash -eux
# Mooched from https://github.com/carlossg/jenkins-swarm-slave-docker/blob/master/jenkins-slave.sh
if [ "$#" -gt 0 ] && [ "$1" == "${1#-}" ]; then
    CMD=()
else
    CMD=(
	java
	${JAVA_OPTS:+$JAVA_OPTS}
	-jar /swarm-client-$JENKINS_SWARM_VERSION.jar
	${MASTER:+-master "$MASTER"}
	${LABELS:+-labels "$LABELS"}
	${USERNAME:+-username "$USERNAME"}
	${PASSWORD:+-passwordEnvVariable PASSWORD}
    )
fi
CMD+=("$@")
exec "${CMD[@]}"
