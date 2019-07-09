#!/usr/bin/env bash

#========================
        #COLORS
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
#========================

# Use to print a message in blue and store the user response as a variable
# VARIABLE=$(prompt "DESIRED PROMPT")
function prompt() {
    read -p "$(echo "${BLUE}$1${NC}")" msg
    echo "$msg"
}

# Use to print a message in yellow
# warn "WARNING MESSAGE"
function warn() {
    echo "${YELLOW}$1${NC}"
}

# Use to print a message in red
# danger "DANGER MESSAGE"
function danger() {
    echo "${RED}$1${NC}"
}
# Use to print a message in green
# success "SUCCESS MESSAGE"
function success() {
    echo "${GREEN}$1${NC}"
}