#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
if [ -n "$BRANCH" ]; then
    if [ -z "$1" ];
        then
            git push origin $BRANCH
        else 
            git push origin $1
    fi
fi
