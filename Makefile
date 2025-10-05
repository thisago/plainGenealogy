# Makefile for genealogy project schema enum refresh

# Input/output paths
DATA=genealogy.yaml
SCHEMA=schema.yaml

# The anchor key (must exist in schema)
ANCHOR=dynamic_PERSON_IDS

.PHONY: update-persons-enum
update-persons-enum:
	yq -i 'del(.available_persons_ids[]) | .available_persons_ids += (load("$(DATA)") | .persons | keys | unique | sort) | .available_persons_ids style="flow"' $(SCHEMA)
