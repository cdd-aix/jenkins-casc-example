up: build
	docker-compose up --detach

up-logs: up
	docker-compose logs --follow

build: docker-compose.yaml
	docker-compose build
