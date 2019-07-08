#!/usr/bin/env bash

cd ~/work
for d in */ ; do
    cd "$d"
    echo "\n $d"
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [[ -n "$BRANCH" ]];
    then
        git stash
        [[ $(git checkout master) ]] && git pull origin master
        [[ $(git checkout beta) ]] && git pull origin beta
        [[ $(git checkout staging) ]] && git pull origin staging
        git checkout $BRANCH
        git stash pop
    fi
    cd ..
done
