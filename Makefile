#!/usr/bin/make
ifneq (,$(wildcard ./.env))
	include .env
	export $(shell sed 's/=.*//' .env)
endif
SHELL=/bin/bash
.PHONY: all help configure-git configure clean build-docker docker-test docker-lint docker-doc docker-publish docker-down docker-kill lint fix-lint test doc rmdoc publish publish-n fix-packages-version version
.ONESHELL:
DCK_CMP_UP=docker-compose up -d --remove-orphans

all: help

help:
	@echo "\tMakefile for notifiable_iterables"
	@echo ''
	@echo "  usage: $0 [COMMAND]"
	@echo ''
	@echo "The available commands are:"
	@echo ''
	@echo "  help           - Print this help text and exit."
	@echo "  configure      - Configure the project folder."
	@echo "  configure-git  - Configure the project folder for git usage. Use 'configure' for global configuration of the project."
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
	flutter pub get

clean:
	flutter clean
	rm -rf coverage
	rm -f .coverage

build-docker:
	docker build -t cynnexis/notifiable_iterables .

docker-test:
	docker run --rm -it cynnexis/notifiable_iterables test

docker-lint:
	docker run --rm -it cynnexis/notifiable_iterables lint

docker-doc:
	docker run --rm -it -v "$$(pwd):/build" cynnexis/notifiable_iterables doc

docker-publish:
	docker run --rm -it cynnexis/notifiable_iterables publish

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

fix-packages-version:
	@set -euo pipefail
	# List all type of dependencies
	dependency_types=('dependencies' 'dev_dependencies')
	for dependency_type in "$${dependency_types[@]}"; do
		# List all dependencies from the pubspec.yaml file
		dependencies=$$(yq --no-colors --no-doc eval ".\"$$dependency_type\" | keys" pubspec.y[a]ml | awk '{print $$2;}')
		while read -r dependency; do
			# Treat only dependencies that have "any" as version
			if [[ $$(yq --no-colors --no-doc eval ".\"$$dependency_type\".\"$$dependency\"" pubspec.y[a]ml 2> /dev/null) == "any" ]]; then
				# Get the version from pubspec.lock
				version=$$(yq --no-colors --no-doc eval ".packages.\"$$dependency\".version" pubspec.lock 2> /dev/null)
				# If the fetched version is valid, put it in the pubspec.yaml
				if [[ -n $$version && $$version != "null" ]]; then
					echo "$$dependency: $$version"
					sed -i -Ee "s@^(\s\+)$${dependency}:\s*any\$$@\1$${dependency}: $$version@g" pubspec.y[a]ml
				else
					echo "Warning: no version found for \"$${dependency}\" from the group \"$${dependency_type}\"" 1>&2
				fi
			fi
		done <<< "$$dependencies"
	done

version:
	@set -e
	VERSION="Package version $$(grep 'version:' pubspec.yaml | head -1 | awk '{print $$2}')"
	if command -v "git" > /dev/null 2>&1; then
		if [[ "$(git rev-parse --abbrev-ref HEAD)" == "master" ]]; then
			echo "$$VERSION"
		else \
			echo "$$VERSION - rev $$(git rev-parse HEAD)"
		fi
	else
		echo "$$VERSION - rev $$(cat ".git/$$(grep "ref:" .git/HEAD | head -1 | awk '{print $$2}')")"
	fi
