# Pass


## About

[Pass](https://www.passwordstore.org/) is a secret store manager used by `Ansible X` to retrieve secrets such as
* the `vault id` for [ansible-vault](bin-generated/ansible-vault.md) 
* and `private key`/`password` for [SSH connections](ans-x-ssh.md)

## Documentation

See the dedicated documentation on how to use `pass`:
* for [ansible-vault](bin-generated/ansible-vault.md)
* for [SSH connections](ans-x-ssh.md)

## Conf

### Default

By default, `pass` is enabled.

```bash
export ANS_X_PASS_ENABLED="1"
```

## Disable/Enable

If `pass` has a Time to live (TTL) configured (ie [Gpg default-cache-ttl](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#index-default_002dcache_002dttl)), it can become annoying
to get a prompt every couple of minutes.

We support 4 modes :
* [enable once and for all](#how-to-enable-it-once-and-for-all)
* [enable on demand](#how-to-disable-it-globally-enable-it-on-demand)
* [disable on demand](#how-to-disable-it-on-demand)
* [disable by script](#how-to-disable-it-for-a-command)

### How to enable it once and for all

You may just work in the shell with [ans-x-shell](bin-generated/ans-x-shell.md). 
An instance is started, `pass` asks your passphrase, 
and you never need to put it again.

Example:
```bash
ans-x-shell
```

### How to disable it globally, enable it on demand

* Disabled it in your `bashrc`
```bash
export ANS_X_PASS_ENABLED="0"
```

Then for every [ansible x scripts](../README.md#ans-x-scripts), you can:
* or enable it with the flag `--ans-x-with-pass` flag
```bash
ansible --ans-x-with-pass 
```
* toggle it with the `--ans-x-pass` flags
```bash
# toggle flag versions, toggle the actual value from 0 to 1
ansible --ans-x-pass
# short versions
ansible --xpass
ansible --xp 
```


### How to disable it on demand

By default, `pass` is enabled

For every [ansible x scripts](../README.md#ans-x-scripts), you can disable it:
* with the flag `--ans-x-without-pass` flag
```bash
ansible --ans-x-without-pass 
```
* with the toggle `--ans-x-pass` flag
```bash
# toggle flag versions, toggle the actual value from 1 to 0
ansible --ans-x-pass
ansible --xpass
ansible --xp 
```

### How to disable it for a command

Not all Ansible Tool needs a secret for every run. 

You can disable pass for specific [script](../README.md#ans-x-scripts)
by setting the `ANS_X_PASS_SCRIPT_DISABLED` with a list of script name separated by a colon.

By default, we disable pass for:
* the [molecule](bin-generated/molecule.md)
* and [ansible-navigator](bin-generated/ansible-navigator.md)
* and [ansible-galaxy](bin-generated/ansible-galaxy.md)

```bash
export ANS_X_PASS_SCRIPT_DISABLED="molecule:ansible-navigator:ansible-galaxy"
```

Note that you can [toggle it on with the toggle flag](#how-to-disable-it-globally-enable-it-on-demand)