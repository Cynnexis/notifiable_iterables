DCK_CMP_UP=docker-compose up -d --remove-orphans

.PHONY: all help configure-git configure build-docker docker-test docker-lint docker-doc docker-publish docker-down docker-kill lint fix-lint test doc rmdoc publish publish-n

all: help

help:
	@echo "\tMakefile for notifiable_iterables"
	@echo ''
	@echo "  usage: $0 [COMMAND]"
	@echo ''
	@echo "The available commands are:"
	@echo ''
	@echo "  configure         - Configure the project folder."
	@echo "  configure-git     - Configure the project folder for git usage. Use 'configure' for global configuration of the project."
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

.git/hooks/pre-commit:
	curl -fsSL "https://gist.githubusercontent.com/Cynnexis/16b64199d9a94684a638f08b3fc893d3/raw/pre-commit" -o ".git/hooks/pre-commit"
	@if command -v "dos2unix" > /dev/null 2>&1; then \
		dos2unix ".git/hooks/pre-commit"; \
	else \
		echo "dos2unix not found. If you are on Windows, you may consider installing it."; \
	fi

configure-git: .git/hooks/pre-commit

configure: configure-git

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

