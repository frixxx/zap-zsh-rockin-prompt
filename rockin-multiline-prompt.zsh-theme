#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -U colors && colors

setopt prompt_subst

precmd() {
    vcs_info
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

# hash changes branch misc
zstyle ':vcs_info:git*' formats "$fg[blue]($reset_color%b%m$fg[blue])$reset_color"
zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.12i %c%u %b%m"

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind ref changes
    local -a gitstatus

    ref=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -n "$ref" ]]; then
        # prepend branch symbol
        ref="$fg[yellow]$fg[magenta]"$ref
    else
        # get tag name or short unique hash @TODO: Testen
        ref=$(git describe --tags --always 2>/dev/null)
        [[ $ref =~ (.*)\-g(.*) ]] && ref="$fg[yellow]$fg[magenta]"${match[2]}
    fi

    [[ -n "$ref" ]] || return
    gitstatus+=( $ref )

    # Read Changes, Ahead and Behind from GIT
    changes=0
    while IFS= read -r line; do
        if [[ $line =~ ^## ]]; then # header line
            [[ $line =~ ahead\ ([0-9]+) ]] && ahead="${match[1]}"
            [[ $line =~ behind\ ([0-9]+) ]] && behind="${match[1]}"
        else # branch is modified if output contains more lines after the header line
            changes=$((changes+1))
        fi
    done < <(git status --porcelain --branch 2>/dev/null)  # note the space between the two <

    [[ "$changes" != "0" ]] && gitstatus+=( "$fg[yellow]*$changes$reset_color" )
    [[ "$ahead" != "" ]] && gitstatus+=( "$fg[yellow]$ahead$reset_color" )
    [[ "$behind" != "" ]] && gitstatus+=( "$fg[yellow]$behind$reset_color" )

    hook_com[branch]="${(j: :)gitstatus}"
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        stashes="$((stashes * 1))" # remove whitespace
        hook_com[misc]+=" $fg[yellow]${stashes}$reset_color"
    fi
}

PROMPT="%(?:🤘🏻 :🖕🏻 )% %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=" $vcs_info_msg_0_ "$'\n'" ↳ "
