.PHONY: shell install install-dev dev build run push release release-multi deploy

PACKAGE_NAME=pytime_v2
DOCKER_REPOSITERY=ghcr.io/dixneuf19
IMAGE_NAME=pytime-v2
IMAGE_TAG=local-$(shell git rev-parse --short HEAD)
DOCKER_IMAGE_PATH=$(DOCKER_REPOSITERY)/$(IMAGE_NAME):$(IMAGE_TAG)

PLATFORMS=linux/amd64,linux/arm64

shell:
	poetry shell

install:
	poetry install

dev:
	poetry run python ${PACKAGE_NAME}/main.py

format:
	poetry run isort .
	poetry run black .

check-format:
	poetry run isort --check .
	poetry run black --check .
	poetry run flake8 .

test:
	poetry run pytest --cov=${PACKAGE_NAME} --cov-report=xml .

build:
	docker build -t $(DOCKER_IMAGE_PATH) .

build-multi:
	docker buildx build --platform $(PLATFORMS) -t $(DOCKER_IMAGE_PATH) .

run: build
	docker run $(DOCKER_IMAGE_PATH)

push:
	docker push $(DOCKER_IMAGE_PATH)

release: build push

release-multi:
	docker buildx build --platform $(PLATFORMS) -t $(DOCKER_IMAGE_PATH) . --push



