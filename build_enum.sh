#!/usr/bin/env bash
# build_enum.sh -- minimal and robust version for yq v4
# Usage: ./build_enum.sh "<ENUM_EXPR>" DATA.yaml SCHEMA.yaml [--anchor dynamic_NAME]
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 \"<ENUM_EXPR>\" DATA.yaml SCHEMA.yaml [--anchor dynamic_NAME]" >&2
  exit 1
fi

ENUM_EXPR="$1"
DATA="$2"
SCHEMA="$3"
shift 3

ANCHOR_KEY=""
while (( "$#" )); do
  case "$1" in
    --anchor)
      shift; ANCHOR_KEY="$1"; shift ;;
    *)
      echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done
if [ -z "$ANCHOR_KEY" ]; then
  ANCHOR_KEY=$(yq -r 'keys | map(select(test("^dynamic_"))) | .[0]' "$SCHEMA")
  if [ -z "$ANCHOR_KEY" ]; then
    echo "Error: No top-level 'dynamic_*' anchor found in schema." >&2
    exit 1
  fi
fi
# Assign array from data to schema
yq -i ".${ANCHOR_KEY} = ($ENUM_EXPR | unique | sort)" "$SCHEMA" "$DATA"
