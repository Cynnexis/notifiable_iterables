DCK_CMP_UP=docker-compose up -d --remove-orphans

.PHONY: all help build-docker docker-test docker-lint docker-doc docker-publish docker-down docker-kill lint fix-lint test doc rmdoc publish publish-n

all: help

help:
	@echo "\tMakefile for notifiable_iterables"
	@echo ''
	@echo "  usage: $0 [COMMAND]"
	@echo ''
	@echo "The available commands are:"
	@echo ''
	@echo "  build-docker   - Build the Docker image associated to this project. All command starting with 'docker-' needs this docker image to work."
	@echo "  docker-test    - Launch the tests from a container."
	@echo "  docker-lint    - Check the code format from a container."
	@echo "  docker-doc     - Generate the documentation from a container."
	@echo "  docker-publish - Publish the flutter package from a container."
	@echo "  docker-down    - Call 'docker-compose down' and prune."
	@echo "  docker-kill    - Kill all docker container. Use this command with caution."
	@echo "  lint           - Check the code format."
	@echo "  fix-lint       - Fix the code format."
	@echo "  test           - Launch the tests."
	@echo "  doc            - Generate the documentation."
	@echo "  rmdoc          - Remove the documentation."
	@echo "  publish        - Publish the flutter package."
	@echo "  publish-n      - Publish the flutter package with the '--dry-run' option (for testing)."

build-docker:
	docker build -t cynnexis/notifiableiterables .

docker-test:
	$(DCK_CMP_UP) test lint

docker-lint:
	$(DCK_CMP_UP) lint

docker-doc:
	docker run --rm -it -v "$$(pwd):/build" cynnexis/notifiableiterables doc

docker-publish:
	docker run --rm -it -v "$$(pwd):/build" cynnexis/notifiableiterables publish

docker-down:
	docker-compose down --remove-orphans --volumes

docker-kill:
	docker rm -f $$(docker ps -aq) || docker rmi -f $$(docker images -f "dangling=true" -q) || docker system prune -f

lint:
	./docker-entrypoint.sh lint

fix-lint:
	./docker-entrypoint.sh fix-lint

test:
	flutter test --coverage test/*_test.dart

doc:
	./docker-entrypoint.sh doc

rmdoc:
	./docker-entrypoint.sh rmdoc

publish:
	./docker-entrypoint.sh publish

publish-n:
	./docker-entrypoint.sh publish --dry-run

