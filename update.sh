#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
function update() {
if [ -z "$1" ];
    then
    if [ $BRANCH == "beta" ];
        then
        git pull origin beta
        return
    fi
    if [ $BRANCH == "master" ];
        then
        git pull origin master
        return
    fi
    echo "Would you like to update from beta or master? (b/m)"
    read BR
    if [ $BR == "beta" ] || [ $BR == "b" ];
        then
        git pull origin beta
        return
    elif [ $BR == "master" ] || [ $BR == "m" ]
        git pull origin master
        return
    else
        echo "Invalid response. Exiting"
        return
    fi
else 
    cd ~/work/$1
    if [ $BRANCH == "beta" ];
        then
        git pull origin beta
        return
    fi
    if [ $BRANCH == "master" ];
        then
        git pull origin master
        return
    fi
fi
}
update