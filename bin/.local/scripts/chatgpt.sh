#/usr/bin/bash

read -p "Enter Question: " query
echo `curl -s https://api.openai.com/v1/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer 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" \
-d "{\"model\": \"text-davinci-003\", \"prompt\": \"$query\", \"temperature\": 1, \"max_tokens\": 4000}" \
| jq '.choices | .[] | .text?' | sed 's/"//g' `

