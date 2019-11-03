#!/usr/bin/env bash

# First the file inventory.json must be created with a call to
#
# azure_rm.py --list --pretty
#
# Then you can get the file formatted to Csv
# with the following jq script
#

cat inventory.json | jq '."_meta"."hostvars" | to_entries[] | [.key, .value.powerstate, .value.virtual_machine_size] | @csv '