#!/usr/bin/env bash

if [ -z "$1" ];
then
    git stash push
else
    CM=""
    for a in "${@:1}"
        do 
        CM+="$a "
        done
    git stash push -m "$CM"
fi