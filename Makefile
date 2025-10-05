# Makefile for genealogy project schema enum refresh

# Input/output paths
DATA=genealogy.yaml
SCHEMA=schema.yaml

# The anchor key (must exist in schema)
ANCHOR=dynamic_PERSON_IDS

.PHONY: update-persons-enum
update-persons-enum:
	ENUM_LIST=$$(yq '.persons | keys | unique | sort' genealogy.yaml); \
	echo "$$ENUM_LIST"; \
	yq -i ".definitions.available_persons_ids = $$ENUM_LIST" schema.yaml; \
	yq -i ".definitions.available_persons_ids style=\"flow\"" schema.yaml
