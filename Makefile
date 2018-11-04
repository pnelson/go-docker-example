.PHONY: dev
dev:
	docker-compose build --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g)
	docker-compose up
