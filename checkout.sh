#!/usr/bin/env bash
if [ -z "$1" ];
then
    git for-each-ref --format=$'%(refname) %09 %(authorname)' 
    read -p "Which branch would you like to checkout? " branch
    [[ -z $branch ]] ||  git checkout $branch || git checkout -b $branch
else 
    git checkout $1 || (
        echo "This branch does not exist, would you like to create it? y/n"
        read new
        if [ $new == "y" ];
        then 
        git checkout -b $1
        fi
    )
fi 
