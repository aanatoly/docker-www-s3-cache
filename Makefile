# See README.md for details
ifeq ($(MAKECMDGOALS),init)
init:
	pip install --user -U semver-tool
else

export CI_COMMIT_DESC := $(shell semver-tool)

define get-tag
$(if $(findstring latest,$1),latest,$(shell semver-tool -f $1))
endef

build_%:
	set -e; \
	export IMAGE_TAG=$(call get-tag,$*); \
	docker-compose build $(NO_CACHE)

push_%: build_%
	set -e; \
	export IMAGE_TAG=$(call get-tag,$*); \
	docker-compose push

up_%: build_%
	set -e; \
	export IMAGE_TAG=$(call get-tag,$*); \
	docker-compose up

endif
