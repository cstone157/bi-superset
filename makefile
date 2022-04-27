# Makefile for controlling and running the postgres database
# Usage: $ make help

THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help cleanup down destroy restart start stop logs ps build init-db

help:
	@echo "Printing help for this make file, used to control/manage the postgresql database project"
	@make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

cleanup: down postgres/.
	docker image rm superset-docker_postgres
	docker image rm superset-docker_superset
	cd postgres && make cleanup
down:
	docker-compose -f docker-compose.yml down $(c)
destroy:
	docker-compose -f docker-compose.yml down -v $(c)
restart: stop start
start: build
	docker-compose -f docker-compose.yml start $(c)
stop:
	docker-compose -f docker-compose.yml stop $(c)
logs:
	docker-compose -f docker-compose.yml logs --tail=100 -f $(c)
ps:
	docker-compose -f docker-compose.yml  ps
build: init-db
	docker-compose -f docker-compose.yml up -d $(c)
init-db: 
	cd postgres && make pre-load-db






