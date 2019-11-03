JENKINS_SWARM_VERSION ?= 3.17
NATIVE_SWARM_FILE = swarm-client-$(JENKINS_SWARM_VERSION)
SWARM_FILE = $(NATIVE_SWARM_FILE).jar
SWARM_FILE_URL = https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$(JENKINS_SWARM_VERSION)/$(SWARM_FILE)
ID = $(shell id -u $$LOGNAME)
DOCKER_RUN_AS_USER = docker run --rm -i -t -v $(PWD):/out -w=/out -u $(ID)
NATIVE_IMAGE = $(DOCKER_RUN_AS_USER) localhost/graalvm-ce-native-image native-image
NATIVE_ID = native-image.id
up: build
	docker-compose up --detach < /dev/null
BUILD_PREREQS = docker-compose.yaml
BUILD_PREREQS += jenkins/Dockerfile
BUILD_PREREQS += jenkins-swarm-agent/Dockerfile
BUILD_PREREQS += jenkins-swarm-agent/$(SWARM_FILE)
BUILD_PREREQS += jenkins-native-swarm-agent/Dockerfile
BUILD_PREREQS += jenkins-native-swarm-agent/$(NATIVE_SWARM_FILE)

build: $(BUILD_PREREQS)
	docker-compose build < /dev/null

jenkins-swarm-agent/$(SWARM_FILE) jenkins-native-swarm-agent/$(SWARM_FILE): $(SWARM_FILE)
	cp -p $^ $@

$(SWARM_FILE):
	wget --timestamping $(SWARM_FILE_URL)

jenkins-native-swarm-agent/$(NATIVE_SWARM_FILE): $(NATIVE_SWARM_FILE)
	cp -p $^ $@

NATIVE_OPTIONS = --no-fallback --no-server
NATIVE_OPTIONS += -H:+AllowVMInspection
NATIVE_OPTIONS += --initialize-at-run-time=sun.awt.dnd.SunDropTargetContextPeer\$$EventDispatcher
NATIVE_OPTIONS += -H:IncludeResourceBundles=org.kohsuke.args4j.Messages
NATIVE_OPTIONS += -H:Optimize=0
NATIVE_OPTIONS += -H:+ReportUnsupportedElementsAtRuntime
NATIVE_OPTIONS += -H:+JNIVerboseLookupErrors
NATIVE_OPTIONS += -H:+RuntimeAssertions
NATIVE_OPTIONS += -H:ClassInitialization=org.kohsuke.args4j.CmdLineParser:run_time,hudson.plugins.swarm.Client:run_time
NATIVE_OPTIONS += --verbose
$(NATIVE_SWARM_FILE): $(SWARM_FILE) $(NATIVE_ID)
	$(NATIVE_IMAGE)  $(NATIVE_OPTIONS) -jar $<
	if ! ./$@ -help; then echo failed; rm -vf $<; exit 1; fi

$(NATIVE_ID): native-image/Dockerfile
	docker image build -t localhost/graalvm-ce-native-image native-image/
	docker image ls -q localhost/graalvm-ce-native-image > $@

cleantest: | realclean up-logs

realclean:
	docker-compose down --rmi all --volumes --remove-orphans

test: | clean up-logs

clean:
	docker-compose down --remove-orphans < /dev/null

up-logs: up
	docker-compose logs --follow --no-color --timestamps --tail=all < /dev/null
