OWNER := zengamingx
REPO_NAME := nightwatch
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
TAG := $(shell echo ${BRANCH_NAME} | sed 's/^master$$/latest/')
COMMIT_HASH := $(shell git rev-parse HEAD)
FULLNAME := ${OWNER}/${REPO_NAME}:${TAG}

build:
	docker build -t ${FULLNAME} .

test:
	docker run --rm -i ${FULLNAME} npm run test:${TEST_STEP}

publish:
	docker push ${FULLNAME}

.PHONY: build test publish pack
