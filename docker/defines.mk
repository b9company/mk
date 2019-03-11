ifndef DOCKER
DOCKER := docker
endif
ifndef DOCKER_REGISTRY
DOCKER_REGISTRY := docker.io
endif

# $(call docker-fqin,image)
#   Return the fully qualified Docker image name, made of registry, repository,
#   and tag.
define docker-fqin
$(DOCKER_REGISTRY)/$(1)
endef

# $(call all-docker-images)
# 	Return all known Docker images from current single-session make. This
# 	assumes Makefile fragments use $(d)/DOCKER_IMAGE to define image names.
# 	(See ./rules.mk)
define all-docker-images
$(sort $(foreach V,$(.VARIABLES),$(if $(findstring /DOCKER_IMAGE,$V),$(call docker-fqin,$($V)))))
endef
