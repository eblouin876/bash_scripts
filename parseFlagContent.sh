#!/usr/bin/env bash

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