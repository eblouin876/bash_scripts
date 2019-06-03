#!/bin/bash


function checkConfig() {
    cd ~/.config
    FILE="shipit"
    if [[ -f "$FILE" ]]; then
        source $FILE
        if [[ ! -z "$email" ]]; then
            if [[ ! -z "$oauth_token" ]]; then
                return
            fi
        fi
        read -p "Please enter your email associated with shipit" email
        read -p "Please enter your oauth token associated with shipit" oauth_token
        cat <<EOF > FILE
email="$email"
oauth_token="$oauth_token"
EOF
    else
        touch shipit
        read -p "Please enter your email associated with shipit: " email
        read -p "Please enter your oauth token associated with shipit: " oauth_token
        cat > shipit <<EOF 
email="$email"
oauth_token="$oauth_token"
EOF
fi
}

checkConfig