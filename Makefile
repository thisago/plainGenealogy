# Makefile for genealogy project schema enum refresh

# Input/output paths
DATA=genealogy.yaml
SCHEMA=schema.yaml

# The anchor key (must exist in schema)
ANCHOR=.available_persons_ids

.PHONY: update-persons-enum
update-persons-enum:
	yq -i 'del($(ANCHOR)[]) | $(ANCHOR) += (load("$(DATA)") | .persons | keys | unique | sort)' $(SCHEMA)
