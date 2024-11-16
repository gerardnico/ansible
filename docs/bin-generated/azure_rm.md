% azure_rm(1) Version Latest | Get inventory in azure 
# NAME

The `azure_rm` to gets and manage Azure inventory definition.

This is pretty old stuff, you would use now 
the [Azure Resource Manager inventory plugin](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_inventory.html)


# SYNOPSIS

```bashDeprecated
azure_rm
```

# HOW TO LIST THE HOSTS

Example on how to list the Azure Hosts
```bash
export AZURE_CLIENT_ID=
export AZURE_SECRET=
export AZURE_SUBSCRIPTION_ID=
export AZURE_TENANT=
azure_rm --list --pretty | jq '."_meta"."hostvars" | to_entries[] | [.key, .value.powerstate, .value.virtual_machine_size] | @csv '
```