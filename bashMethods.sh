#!/bin/bash
#======================== Import ========================
. ~/.scripts/.env

#========================================================

#======================== Colors ========================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;96m'
NC='\033[0m'
#=========================================================

#======================== Helpers ========================
# Use to print a message in cyan
# cyan "CYAN MESSAGE"
function cyan() {
    echo -e "${CYAN}$1${NC}"
}

# Use to print a message in red
# danger "DANGER MESSAGE"
function danger() {
    echo -e "${RED}$1${NC}"
}

# Use to print a message in blue and store the user response as a variable
# VARIABLE=$(prompt "DESIRED PROMPT")
function prompt() {
    read -p "$(echo -e "${BLUE}$1${NC}")" msg
    echo "$msg"
}

# Use to print a message in green
# success "SUCCESS MESSAGE"
function success() {
    echo -e "${GREEN}$1${NC}"
}

# Use to print a message in yellow
# warn "WARNING MESSAGE"
function warn() {
    echo -e "${YELLOW}$1${NC}"
}
#================================================================

# ======================== Main Mehthods ========================
function branches() {
    git remote update origin --prune && git branch -av
}

# Smart commit method
# Takes a -a flag if you want to commit all tracked files (like git commit -am)
# If there are staged changes it will commit those with the message provided
# If there are no staged changes but modified files it will prompt you to select files to include in the commit
# If there are no staged changes and only a single modified file, it will automatically stage that file and commit it
# If there are untracked files, it will prompt asking if you want to add any of them.
function commit() {
    ADDUNTR=""
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
        MODIFIED=($(git status | grep '^\s*modified:' | cut -f 2- -d :))
        MODIFIED+=($(git status | grep '^\s*deleted:' | cut -f 2- -d :))
        UNTRACKED=($(git status | grep -A99 Untracked | grep '^\s(.|[a-z])' | tr -d "[:blank:]"))
        [[ -n "$UNTRACKED" ]] && ADDUNTR=($(prompt "You have untracted files. Do you wish to add them? (y/n): "))
        if [[ "$ADDUNTR" == "y" ]];
        then
            for ((i=0; i < ${#UNTRACKED[@]}; i++ )); do
                FILE=${UNTRACKED[i]}
                cyan "\t$i: $FILE"
            done
            SEL=($(prompt "Enter the numbers you wish to add for this commit separated by a space: "))
            if [[ -n "$SEL" ]]; then
                for ((i=0; i< ${#SEL[@]}; i++ )); do
                    FILEADD=${UNTRACKED[$((${SEL[i]}))]}
                    git add $FILEADD
                done
            fi
        fi
        STAGED="$(git status | grep 'Changes to be committed:')"
        if [[ -n "$MODIFIED" ]] && [[ -z "$STAGED" ]] && [[ ${#MODIFIED[@]} > 1 ]]; then
            for ((i=0; i < ${#MODIFIED[@]}; i++ )); do
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
        if [[ -n "$MODIFIED" ]] && [[ -z "$STAGED" ]] && [[ ((${#MODIFIED[@]} == 1)) ]];then
            git add ${MODIFIED[0]}
        fi
        CM=""
        for a in "${@:1}"
            do
            CM+="$a "
            done
        git commit -m "$BRANCH: $CM"
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

function copen() {
    if [ -z "$1" ];
    then
        code ~/work
    else
        code ~/work/$1
    fi
}

# Stashes all changes - will take a message from whatever was passed after stash
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

# Deletes a branch AND its remote repository
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

# Silently deletes any uncommitted changes
function drop() {
    git stash &> /dev/null && git stash drop stash@{0} &> /dev/null
}

# excludes gemfile.lock and yarn.lock
function gd() {
    BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
    EXCLUDE="-- . :(exclude)Gemfile.lock :(exclude)yarn.lock"
    [[ -z "$1" ]] && git diff $EXCLUDE && return;
    git diff remotes/origin/$1..$BRANCH $EXCLUDE
}

# database name, file path
function importDb() {
    DATABASE="$1"
    FILE="$2"
    mysql -u root -p $DATABASE < $FILE
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

function reload() {
    . ~/.bashrc && . ~/.bash_profile
}

function status() {
    git status
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

function updateAdminLogin(){
    DIR=${PWD}
    cd ~/work/guide
    rails runner "
    e = User.where(email: '$email').first
    e.password = '$adminpass'
    e.password_confirmation = '$adminpass'
    e.save
    "
    cd DIR
}