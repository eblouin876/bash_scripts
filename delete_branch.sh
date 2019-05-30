#!/usr/bin/env bash
BRANCH="$(git branch 2>/dev/null | grep "\*" | colrm 1 2)"
DBRAN="$1"
function delete() {
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
else
    git branch -D $DBRAN
fi
}
delete