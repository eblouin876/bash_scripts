#!/usr/bin/env bash

if [ -z "$1" ];
then
    echo "Please levea a commit message!"
else
    CM=""
    for a in "${@:1}"
        do 
        CM+="$a "
        done
    git commit -am "$CM"
fi