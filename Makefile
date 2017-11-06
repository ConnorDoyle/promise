.PHONY: \
	all \
	deps \
	lint \
	test

MKFILE_DIR := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

SOURCES := "."

TEST_FILTER := Test

all: deps format lint test

format:
	@ echo "Formatting source code"
	git ls-files "**.go" | xargs -n1 gofmt -e -s -w

fgt:
	@ if ! which fgt > /dev/null; then \
			echo "fgt not found, attempting to install" >&2; \
			if ! go get github.com/GeertJohan/fgt; then \
				exit 1; \
			fi \
		fi
	fgt

lint: fgt
	@ if ! which golint > /dev/null; then \
			echo "Golint not found, attempting to install" >&2; \
			if ! go get github.com/golang/lint/golint; then \
				exit 1; \
			fi \
		fi
	@ echo "Linting source code"
	echo $(SOURCES) | xargs -n1 fgt golint

test:
	@ echo "Running unit tests"
	go test -v $(SOURCES)

deps: fgt
	@ echo "Restoring source dependencies (requires 'dep')"
	@ echo "  See https://github.com/golang/dep"
	@ if ! which dep > /dev/null; then \
			echo "dep not found, attempting to install" >&2; \
			if ! go get -u github.com/golang/dep/cmd/dep; then \
				exit 1; \
			fi \
		fi
	@ dep ensure
