#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"

if [ -z "$1" ];
then
    git stash push
else
    CM=""
    for a in "${@:1}"
        do 
        CM+="$a "
        done
    git stash push -m "$BRANCH: $CM"
fi