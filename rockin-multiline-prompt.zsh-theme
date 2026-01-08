#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -U colors && colors
PLUGIN_DIRECTORY=${0:A:h}
source $PLUGIN_DIRECTORY/lib/functions.zsh
CONFIG_DIRECTORY="${HOME}/.config/fx/rockin-multiline-prompt"
ALIAS_FILE="${CONFIG_DIRECTORY}/aliases"
ENV_FILE="${CONFIG_DIRECTORY}/.env"
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
CLI_BINARY_PATHS=( "${ROCKIN_MULTILINE_PROMPT___CLI_BINARY_PATHS:-}" )

[[ -z "${RMP_ICON_BRANCH}" ]] && RMP_ICON_BRANCH=""
[[ -z "${RMP_ICON_COMMIT}" ]] && RMP_ICON_COMMIT=""
[[ -z "${RMP_ICON_CHANGES}" ]] && RMP_ICON_CHANGES="*"
[[ -z "${RMP_ICON_AHEAD}" ]] && RMP_ICON_AHEAD=""
[[ -z "${RMP_ICON_BEHIND}" ]] && RMP_ICON_BEHIND=""
[[ -z "${RMP_ICON_STASH}" ]] && RMP_ICON_STASH="≡"

##### Configure Prompt #####
HOSTNAME=`hostname`
USER=`whoami`

setopt prompt_subst

precmd() {
    vcs_info
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*' formats " $fg[blue]($reset_color%b%m$fg[blue])$reset_color"
zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.12i %c%u %b%m"
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash


if [[ -z "${RMP_SERVER_MODE}" ]]; then
    PROMPT="🤘 %{$fg[cyan]%}%~%{$reset_color%}"
    PROMPT+="\$vcs_info_msg_0_ "$'\n'" ↳ "
else 
    PROMPT="🤘 %{$fg[cyan]%}${USER}@${HOSTNAME}:%{$fg[cyan]%}%~%{$reset_color%}"
    PROMPT+="\$vcs_info_msg_0_ "$'\n'" ↳ "
fi

##### History Plugin Config #####
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

##### Load Aliases #####
[[ -f "${ALIAS_FILE}" ]] && source "${ALIAS_FILE}"

##### Expand Application Paths
extendPATHEnvironmentVariable
