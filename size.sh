#!/usr/bin/env bash

if [ "$1" = "-m" ];
then
    echo "$(( $(stat -f%z $2)/1000000 )) mb"
elif [ "$1" = "-k" ];
then
    echo "$(( $(stat -f%z $2)/1000 )) kb"
else
    echo "$(( $(stat -f%z $1)/1000 )) kb"
fi