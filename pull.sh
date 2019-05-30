#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
if [ -n "$BRANCH" ]; then
if [ -z "$1" ];
then
    git pull origin $BRANCH
else 
    git pull origin $1
fi
fi
