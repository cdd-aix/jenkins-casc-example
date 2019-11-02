test: | clean up-logs

clean:
	docker-compose down --remove-orphans < /dev/null

up-logs: up
	docker-compose logs --follow --no-color --timestamps --tail=all < /dev/null

up: build
	docker-compose up --detach < /dev/null

build: docker-compose.yaml
	docker-compose build < /dev/null

cleantest: | realclean up-logs

realclean:
	docker-compose down --rmi all --volumes --remove-orphans
