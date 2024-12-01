# How to use Ans-X Scripts in your scripts

# Disable Terminal

By default, we allocate a terminal to output colors.

If you use `Ans-x` in a script to retrieve data, you need to disable this behavior
so that you don't get any terminal specific characters.

```bash
export ANS_X_DOCKER_TERMINAL=0
```

# Example

A one-liner example on how to extract the [COLLECTIONS_PATHS env](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths)
of [ansible-galaxy](bin-generated/ansible-galaxy.md) with [ansible-config](bin-generated/ansible-config.md)

```bash
COLLECTION_PATHS=$(ANS_X_DOCKER_TERMINAL=0 ansible-config dump | grep "COLLECTIONS_PATHS")
```

Note: If you can, it's better to ask for an export format output (such as Json)
In this case, no terminal characters will be in the output, and you don't need to set `ANS_X_DOCKER_TERMINAL`
```bash
COLLECTION_PATHS=$(
  ansible-config dump --format json \
    | jq '.[] | select(.name == "COLLECTIONS_PATHS").value | @sh'
  )
```