#!/usr/bin/env zsh

autoload -U colors && colors
precmd_vcs_info() { __git_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

__git_info() {
    hash git 2>/dev/null || return # git not found
    LANG=C
    local git_eng="LANG=C git"   # force git output in English to make our work easier

    # get current branch name
    local ref=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -n "$ref" ]]; then
        # prepend branch symbol
        ref="$fg[yellow]$reset_color $fg[magenta]"$ref
    else
        # get tag name or short unique hash @TODO: Testen
        ref=$(git describe --tags --always 2>/dev/null)
        [[ $ref =~ (.*)\-g(.*) ]] && ref="$fg[yellow] $fg[magenta]"${match[2]}
    fi

    [[ -n "$ref" ]] || return  # not a git repo

    local marks

    # scan first two lines of output from `git status`
    i=0
    while IFS= read -r line; do
        if [[ $line =~ ^## ]]; then # header line
            [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $fg[yellow]${match[1]}"
            [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $fg[yellow]${match[1]}"
        else # branch is modified if output contains more lines after the header line
            i=$((i+1))
        fi
    done < <(git status --porcelain --branch 2>/dev/null)  # note the space between the two <

    if [[ "$i" != "0" ]]; then
      marks=" $fg[yellow]*$i$marks"
    fi

    # print the git branch segment without a trailing newline
    VCS_INFO=$(printf " $fg[blue]($reset_color$ref$marks$fg[blue])$reset_color")
}

NEXTLINE=$'\n'

export PROMPT="%(?:🤘🏻 :🖕🏻 )% %{$fg[cyan]%}%~%{$reset_color%}$VCS_INFO $NEXTLINE ↳ "
