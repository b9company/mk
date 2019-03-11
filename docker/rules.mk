# Usage: include this file from where the Dockerfile is located. The build
# environment relies on global Makefile variables, which can be overridden from
# the command-line, and local Makefile variables, which you can set to customize
# the build to your needs.
#
# DOCKER_REGISTRY:
# 	(global) The Docker registry where images are pushed to.
#
# DOCKER_PUSH:
#   (global) Whether to push to DOCKER_REGISTRY. False by default.
#
# $(d)/DOCKER_IMAGE:
#   (local) The base name of the Docker image.
#
# $(d)/DOCKER_TAG:
#   (local) The tag of the Docker image.
#
# $(d)/DOCKER_BUILD_CONTEXT:
#   (local) By default, set to the directory where the Dockerfile is stored.
#           This can be overridden to provide a wider build context.
#
# $(d)/DOCKER_BUILD_ARGS:
#   (local) Build-time variables for the docker build command.

.PHONY: docker-build\:$(d)
docker-build\:$(d): IMAGE := $(call docker-fqin,$($(d)/DOCKER_IMAGE))
docker-build\:$(d): BUILD_ARGS := $($(d)/DOCKER_BUILD_ARGS)
ifdef $(d)/DOCKER_BUILD_CONTEXT
docker-build\:$(d): BUILD_CONTEXT := $($(d)/DOCKER_BUILD_CONTEXT)
else
docker-build\:$(d): BUILD_CONTEXT := $(d)
endif
docker-build\:$(d): $(d)/Dockerfile
	@echo "Building Docker image '$(IMAGE)'"; \
	echo "  dockerfile    = $<"; \
	echo "  build context = $(BUILD_CONTEXT)"; \
	echo "  build args    = $(BUILD_ARGS)"; \
	echo "  push to       = $(if $(DOCKER_PUSH),$(DOCKER_REGISTRY))";
	tar -c $(BUILD_CONTEXT) | \
		$(DOCKER) build -t $(IMAGE) $(BUILD_ARGS) -f $< -
ifeq ($(DOCKER_PUSH),true)
	$(DOCKER) push $(IMAGE)
endif
	@echo

BUILD := $(BUILD) docker-build\:$(d)
