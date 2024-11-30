# bin docker

## About
This directory has files that are mounted inside `Docker`.

* `bin` contains extra ansible binary
* `home` contains files that overwritten when the home is mounted
  * docker config.json is overwritten otherwise it's not happy with the `desktop`
```json
{
  "credsStore": "desktop.exe"
}
```