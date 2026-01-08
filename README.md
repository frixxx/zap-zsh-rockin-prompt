# Rockin Multiline Prompt
A simple theme to use with zap

It renders the zap-prompt `🤘🏻` followed by VCS info (if in a repo directory) and a line break!
Followed by a command indicator `↳`.

> # @TODO: Add a screenshot

## Configuration

Create oder edit the file `~/.config/fx/rockin-multiline-prompt/.env` and provide the following Environment Variables:

```bash
ROCKIN_MULTILINE_PROMPT___CLI_BINARY_PATHS=(
	'/Applications/Sublime Text.app/Contents/SharedSupport/bin'
	'/Applications/PhpStorm.app/Contents/MacOS'
	'/Applications/IntelliJ IDEA.app/Contents/MacOS'
	'/opt/homebrew/opt/ruby/bin'
)
```

## Aliases

Create oder edit the file `~/.config/fx/rockin-multiline-prompt/aliases` and provide aliases like so:

```bash
alias gsr="git-switch remote"
alias cat=bat
```
