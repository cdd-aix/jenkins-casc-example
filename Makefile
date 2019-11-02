JENKINS_SWARM_VERSION ?= 3.17
NATIVE_SWARM_FILE = swarm-client-$(JENKINS_SWARM_VERSION)
SWARM_FILE = $(NATIVE_SWARM_FILE).jar
SWARM_FILE_URL = https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$(JENKINS_SWARM_VERSION)/$(SWARM_FILE)
ID = $(shell id -u $LOGNAME)
DOCKER_RUN_AS_USER = docker run --rm -i -t -v $(PWD):/out -w=/out -u $(ID)
NATIVE_IMAGE = $(DOCKER_RUN_AS_USER) localhost/graalvm-ce-native-image native-image
up: build
	docker-compose up --detach < /dev/null
BUILD_PREREQS = docker-compose.yaml
BUILD_PREREQS += jenkins/Dockerfile
BUILD_PREREQS += jenkins-swarm-agent/Dockerfile
BUILD_PREREQS += jenkins-swarm-agent/$(SWARM_FILE)
# BUILD_PREREQS += jenkins-native-swarm-agent/Dockerfile
# BUILD_PREREQS += jenkins-native-swarm-agent/$(NATIVE_SWARM_FILE)

build: $(BUILD_PREREQS)
	docker-compose build < /dev/null

jenkins-swarm-agent/$(SWARM_FILE) jenkins-native-swarm-agent/$(SWARM_FILE): $(SWARM_FILE)
	cp -p $^ $@

$(SWARM_FILE):
	wget --timestamping $(SWARM_FILE_URL)


cleantest: | realclean up-logs

realclean:
	docker-compose down --rmi all --volumes --remove-orphans

test: | clean up-logs

clean:
	docker-compose down --remove-orphans < /dev/null

up-logs: up
	docker-compose logs --follow --no-color --timestamps --tail=all < /dev/null
