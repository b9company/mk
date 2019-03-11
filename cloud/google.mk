# $(call cloud-google-project,project-name)
#   Return 'google:project-name'.
define cloud-google-project
google:$(strip $(1:google:%=%))
endef

# $(call cloud-google-cluster,cluster-name)
#		Return 'google:project-name/compute-zone/cluster-name, where project-name is
#		from GCP_PROJECT environment variable, and compute-zone is from
#		GOOGLE_COMPUTE_ZONE environment variable.
define cloud-google-cluster
$(call cloud-google-project,$(GCP_PROJECT))/$(strip $(GOOGLE_COMPUTE_ZONE))/$(strip $(1))
endef

# $(call cloud-google-bucket,bucket-name)
#   Return 'gs://bucket-name'.
define cloud-google-bucket
gs://$(strip $(1:gs://%=%))
endef
