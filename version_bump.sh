#!/usr/bin/env bash

VER="$1"
PDT="$2"
regex="20[0-9][0-9].[0-1][0-9].[0-3][0-9]"

function runGit() {
    BRANCH = $2
    git checkout $BRANCH
    git pull origin $BRANCH
    git checkout versionBump || git checkout -b versionBump
    git pull origin $BRANCH
    sed -i "" "s/'chimera-edu', '= [0-9][0-9][0-9][0-9].[0-9][0-9].[0-9][0-9].rev[0-9]*'/'chimera-edu', '= $1.rev$VER'/" Gemfile
    bundle update --group=internal && yarn upgrade chimera-edu && yarn upgrade edu-styles && yarn upgrade optimal-js
                        
    git diff
    read -p "Are you ready to push to versionBump and open a PR? (y/n): " READY
    if [ $READY == 'y' ];
    then
        git commit -am "version bump"
        git push origin versionBump
        source ~/.config/shipit
        hub pull-request --no-edit -b master | ( read PR_URL; curl -H "Content-Type: application/json"  -d "{\"number_or_url\":\"$PR_URL\", \"email\":\"$email\", \"stack_id\":24}" --header "Authorization: Token token=\"$oauth_token\", email=\"$email\"" -X POST https://admin.optimal.com/api/v1/shipit/pull_requests )
        git checkout $BRANCH
        git branch -D versionBump
    else
        return
    fi
}

function bump() {
    checkConfig
    read -p "Are you version bumping beta or master? (b/m): " MAST 
    if [ $MAST = "b" ];
        then
        BRANCH="beta"
    elif [ $MAST = "m" ];
        then
        BRANCH="master"
    else
        echo "Invalid response. Exiting"
        return
    fi
    DT=`date +"%Y.%m.%d"`
    if [ -z "$VER" ];
    then
        echo "You must provide a version number"
    elif [ -z "$PDT" ];
    then
        echo "You passed in a version without a date. The date will default to $DT"
        read -p "Do you want to continue with gem 'chimera-edu', '= $DT.rev$VER? (y/n): " CONT
        if [ $CONT == "y" ];
        then
            runGit $DT $BRANCH
        else
            read -p "What date would you like to use? Must be in yyyy.mm.dd format: " IDT
            if [[ $IDT =~ $regex ]];
            then
                runGit $IDT $BRANCH
            else
                echo "Incorrect or invalid date"
                return
            fi
        fi 
    else
        read -p "Do you want to continue with gem 'chimera-edu', '= $DT.rev$VER? (y/n): " CONT
        if [ $CONT == "y" ];
        then
            if [[ $PDT =~ $regex ]];
            then
                runGit $PDT $BRANCH
            else
                echo "Incorrect or invalid date"
            return
            fi
        else
            return
        fi
    fi
}

bump