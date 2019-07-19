#!/bin/bash

#========================
        #COLORS
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;96m'
NC='\033[0m'
#========================

# Use to print a message in blue and store the user response as a variable
# VARIABLE=$(prompt "DESIRED PROMPT")
function prompt() {
    read -p "$(echo -e "${BLUE}$1${NC}")" msg
    echo "$msg"
}

# Use to print a message in yellow
# warn "WARNING MESSAGE"
function warn() {
    echo -e "${YELLOW}$1${NC}"
}

# Use to print a message in red
# danger "DANGER MESSAGE"
function danger() {
    echo -e "${RED}$1${NC}"
}

# Use to print a message in green
# success "SUCCESS MESSAGE"
function success() {
    echo -e "${GREEN}$1${NC}"
}

# Use to print a message in green
# success "SUCCESS MESSAGE"
function cyan() {
    echo -e "${CYAN}$1${NC}"
}

function commit() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [ -z "$1" ];
    then
        echo "Please leave a commit message!"
    elif [ "$1" == "-a" ];
    then
        CM=""
        for a in "${@:2}"
            do
            CM+="$a "
            done
        git commit -am "$BRANCH: $CM"
    else
        STAGED="$(git status | grep 'Changes to be committed:')"
        MODIFIED=($(git status | grep '^\s*modified:' | cut -f 2- -d :))
        if [[ -n "$MODIFIED" ]] && [[ -z "$STAGED" ]]; then
            for ((i=0; i< ${#MODIFIED[@]}; i++ )); do
                FILE=${MODIFIED[i]}
                cyan "\t$i: $FILE"
            done
            SEL=($(prompt "Enter the numbers you wish to add for this commit separated by a space: "))
            if [[ -n "$SEL" ]]; then
                for ((i=0; i< ${#SEL[@]}; i++ )); do
                    FILEADD=${MODIFIED[$((${SEL[i]}))]}
                    git add $FILEADD
                done
            fi
        fi
        CM=""
        for a in "${@:1}"
            do
            CM+="$a "
            done
        git commit -m "$BRANCH: $CM"
    fi
}

function stash() {
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
}

function checkout() {
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
}

function dbranch() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    DBRAN="$1"
    if [ -z $DBRAN ];
    then
        echo "No branch name given"
        return
    elif [ "$DBRAN" == "$BRANCH" ];
    then
        echo "You can't delete the branch you are on"
        return
    elif [ "$DBRAN" == "master" ];
    then
        echo "You can't delete master!"
        return
    elif [ "$DBRAN" == "beta" ];
    then
        echo "You can't delete beta!"
        return
    elif [ "$DBRAN" == "staging" ];
    then
        echo "You can't delete staging!"
        return
    elif [ "$DBRAN" == "production" ];
    then
        echo "You can't delete production!"
        return
    else
        git push origin --delete $DBRAN
        git branch -D $DBRAN
    fi
}

function pull() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [ -n "$BRANCH" ];
        then
        if [ -z "$1" ];
        then
            git pull origin $BRANCH
        else
            git pull origin $1
        fi
    fi
}

function push() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    if [ -n "$BRANCH" ]; then
        if [ -z "$1" ];
            then
                git push origin $BRANCH
            else
                git push origin $1
        fi
    fi
}

function update() {
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
        echo ""
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
            echo ""
        else
            echo "You entered an invalid project name."
        fi
    fi
}

function updateAll() {
    cd ~/work
    for d in */ ; do
        cd "$d"
        echo ""
        echo "$d"
        BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
        if [[ -n "$BRANCH" ]];
        then
            git stash push -m "update_stash_$1_$BRANCH"
            [[ $(git checkout master) ]] && git pull origin master
            [[ $(git checkout beta) ]] && git pull origin beta
            [[ $(git checkout staging) ]] && git pull origin staging
            git checkout $BRANCH
            STASH=$(git stash list --grep="update_stash_$1_$BRANCH" | cut -d: -f1)
            [[ -n "$STASH" ]] && git stash pop $STASH
        fi
        cd ..
    done
}

function copen() {
    if [ -z "$1" ];
    then
        code ~/work
    else
        code ~/work/$1
    fi
}

function size() {
    if [ "$1" = "-m" ];
    then
        echo "$(( $(stat -f%z $2)/1000000 )) mb"
    elif [ "$1" = "-k" ];
    then
        echo "$(( $(stat -f%z $2)/1000 )) kb"
    else
        echo "$(( $(stat -f%z $1)/1000 )) kb"
    fi
}

function importDb() {
    DATABASE="$1"
    FILE="$2"
    mysql -u root -p $DATABASE < $FILE
}

function status() {
    git status
}

function gd() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    EXCLUDE="-- . :(exclude)Gemfile.lock :(exclude)yarn.lock"
    [[ -z "$1" ]] && git diff $EXCLUDE && return;
    git diff remotes/origin/$1..$BRANCH $EXCLUDE
}

function branches() {
    git remote update origin --prune && git branch -av
}

function drop() {
    git stash &> /dev/null && git stash drop stash@{0} &> /dev/null
}

function master() {
    git checkout master
}

# Will parse text between two flags and return it as a single string
function parseFlagContent() {
    POS=$1
    ARR=("${@:2}")
    POS=$((POS+1))
    while [[ ! -z "${ARR[$POS]}" ]] && [[ ${ARR[$POS]} != "-"* ]] && [[ "${ARR[$POS]}" != "" ]]
    do
        [[ -z "$MSG" ]] && MSG="${ARR[$POS]}" || MSG="$MSG ${ARR[$POS]}"
        POS=$((POS+1))
    done
    echo "$MSG"
}

# More here as a reminder
function parseFlags() {
    if [[ $@ ]]; then
        parsedArr=()
        arr=( "$@" )
        for ((i=0; i< ${#arr[@]}; i++ )); do
            var=${arr[i]}
            if [[ $var == "-"* ]]; then
                CONTENT="$(parseFlagContent $i $@)"
            fi
        done
        echo ${parsedArr[1]}
    fi
}
