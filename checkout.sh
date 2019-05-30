#!/usr/bin/env bash
if [ -z "$1" ];
then
    echo "Branch missing"
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
