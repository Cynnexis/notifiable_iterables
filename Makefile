DCK_CMP_UP=docker-compose up -d --remove-orphans

.PHONY: build-docker docker-test docker-lint docker-doc docker-publish docker-down docker-kill lint fix-lint test doc rmdoc publish publish-n

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

