#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -U colors && colors
PLUGIN_DIRECTORY=${0:A:h}
source $PLUGIN_DIRECTORY/../lib/functions.zsh

[[ -z "${RMP_ICON_BRANCH}" ]] && RMP_ICON_BRANCH=""
[[ -z "${RMP_ICON_COMMIT}" ]] && RMP_ICON_COMMIT=""
[[ -z "${RMP_ICON_CHANGES}" ]] && RMP_ICON_CHANGES="*"
[[ -z "${RMP_ICON_AHEAD}" ]] && RMP_ICON_AHEAD=""
[[ -z "${RMP_ICON_BEHIND}" ]] && RMP_ICON_BEHIND=""
[[ -z "${RMP_ICON_STASH}" ]] && RMP_ICON_STASH="≡"

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

PROMPT="%(?:🤘🏻 :🖕🏻 )% %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+="\$vcs_info_msg_0_ "$'\n'" ↳ "
