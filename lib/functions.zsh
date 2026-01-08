# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind ref changes
    local -a gitstatus

    ref=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -n "$ref" ]]; then
        # prepend branch symbol
        ref="$fg[yellow]$RMP_ICON_BRANCH$fg[magenta]"$ref
    else
        # get tag name or short unique hash @TODO: Testen
        ref="$fg[yellow]$RMP_ICON_COMMIT$fg[magenta]"$(git describe --tags --always 2>/dev/null)
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

    [[ "$changes" != "0" ]] && gitstatus+=( "$fg[yellow]$RMP_ICON_CHANGES$changes$reset_color" )
    [[ "$ahead" != "" ]] && gitstatus+=( "$fg[yellow]$RMP_ICON_AHEAD$ahead$reset_color" )
    [[ "$behind" != "" ]] && gitstatus+=( "$fg[yellow]$RMP_ICON_BEHIND$behind$reset_color" )

    hook_com[branch]="${(j: :)gitstatus}"
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        stashes="$((stashes * 1))" # remove whitespace
        hook_com[misc]+=" $fg[yellow]$RMP_ICON_STASH${stashes}$reset_color"
    fi
}

function extendPATHEnvironmentVariable() {
  dirs=( $@ )
  echo="dirs: ${dirs}"
  for cliPath in "${dirs[@]}"; do
    echo "${cliPath}"
    if [[ -d $cliPath ]]; then
      export PATH="$cliPath:$PATH"
    fi
  done

}
