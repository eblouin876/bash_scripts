#!/usr/bin/env bash
if [ -z "$1" ];
then
    code ~/work
else 
    cd ~/work/$1
    code .
fi
