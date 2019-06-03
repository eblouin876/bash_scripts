#!/usr/bin/env bash

if [ -z "$1" ];
then
    echo "Please leve a pr message!"
else
    read -p "Do you want to open a pr into master or beta? (b/m): " base
    [[ $base == "b" ]] && BASE="beta"
    [[ $base == "m" ]] && BASE="master"
    if [ -z $BASE ]; then 
        echo "You entered an invalid base branch"
        return
    else
        if [ $1 == "-m" ]; then 
            CM=""
            for a in "${@:2}"
                do 
                CM+="$a "
                done
            hub pull-request --base $BASE --push --message "$CM"
        else
            hub pull-request --base $BASE --push --no-edit
        fi
    fi
fi