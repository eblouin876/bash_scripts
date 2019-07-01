#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"

if [[ -z $1 ]];
    then
    if [ "$BRANCH" == "beta" ];
        then
        git pull origin beta
    elif [ "$BRANCH" == "master" ];
        then
        git pull origin master
    else
        echo "Would you like to update from beta or master? (b/m)"
        read BR
        if [ "$BR" == "beta" ] || [ "$BR" == "b" ];
            then
            git pull origin beta
        elif [ "$BR" == "master" ] || [ "$BR" == "m" ];
            then
            git pull origin master
        else
            echo "Invalid response. Exiting"
        fi
    fi
else 
    cd ~/work/$1
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [ "$BRANCH" == "beta" ];
        then
        git pull origin beta
    else [ "$BRANCH" == "master" ]
        git pull origin master
    fi
fi
