#!/usr/bin/env bash

if [[ -z "$1" ]];
then
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [[ -n "$BRANCH" ]];
    then
        git stash push -m "update_stash_$BRANCH"
        git checkout master && git pull origin master
        git checkout beta && git pull origin beta
        git checkout staging && git pull origin staging
        git checkout $BRANCH
        STASH=$(git stash list --grep="update_stash_$BRANCH" | cut -d: -f1)
        [[ -n "$STASH" ]] && git stash pop $STASH
    fi
    echo "\n"
else 
    if cd ~/work/$1; then
        echo "$1"
        BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
        if [[ -n "$BRANCH" ]];
        then
            git stash push -m "update_stash_$1_$BRANCH"
            git checkout master && git pull origin master
            git checkout beta && git pull origin beta
            git checkout staging && git pull origin staging
            git checkout $BRANCH
            STASH=$(git stash list --grep="update_stash_$1_$BRANCH" | cut -d: -f1)
            [[ -n "$STASH" ]] && git stash pop $STASH
        fi
        echo "\n"
    else
        echo "You entered an invalid project name."
    fi
fi
