.PHONY: \
	all \
	deps \
	lint \
	test

MKFILE_DIR := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

PKG_PREFIXES := pkg
SOURCES := $(foreach p,$(PKG_PREFIXES),./$(p)/...)

TEST_FILTER := Test

all: deps format lint test

format:
	@ echo "Formatting source code"
	git ls-files "**.go" | xargs -n1 gofmt -e -s -w

lint:
	@ if ! which fgt > /dev/null; then \
			echo "fgt not found, attempting to install" >&2; \
			if ! go get github.com/GeertJohan/fgt; then \
				exit 1; \
			fi \
		fi
	@ if ! which golint > /dev/null; then \
			echo "Golint not found, attempting to install" >&2; \
			if ! go get github.com/golang/lint/golint; then \
				exit 1; \
			fi \
		fi
	@ echo "Linting source code"
	echo $(SOURCES) | xargs -n1 fgt golint

# go test regex filtering is supported to influence the set of tests run.
#
# To override TEST_BUILD_TAGS use the -e option as follows:
# TEST_FILTER=Promise make -e
test:
	@ echo "Running unit tests"
	go test -v $(SOURCES) -run $(TEST_FILTER)

deps:
	@ echo "Restoring source dependencies (requires `dep`)"
	@ echo "  See https://github.com/golang/dep"
	dep ensure
