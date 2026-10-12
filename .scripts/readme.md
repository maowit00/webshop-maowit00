# Scripting WebShop

Attempting automation scripts.

[Infrastructure as Code (IaC)](https://en.wikipedia.org/wiki/Infrastructure_as_code)

If it works great!

If not hard copy of commands to run.

A script is nothing more than a line the get feed to an interpreter.

Stuff goes wrong, and need to be reset.

> The nuclear option is a fundamental human right to any software developer.

That possibility should prompt any machine to behave.

## [.env](/.scripts/setup/.env)

Shared environment variables defined once and needed by the various scripts.

> should be ignored by git

- Force add to git:

```console
git add -f .env
```

## Link to $HOME

Scripts assumes that `$HOME/.scripts` exists and where all scripts are located.

Makes stuff easier.

The `.scripts` makes it easier for shell to autocomplete.
