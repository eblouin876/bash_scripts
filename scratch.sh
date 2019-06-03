#!/bin/bash

source ~/.config/shipit
echo "$email"
echo "$oauth_token"
pr_URL="test"

curl -H "Content-Type: application/json"  -d "{\"number_or_url\":\"$pr_URL\", \"email\":\"$email\", \"stakc_id\":24}" --header "Authorization: Token token=\"$oauth_token\", email=\"$email\"" -X POST https://admin.optimal.com/api/v1/shipit/pull_requests
