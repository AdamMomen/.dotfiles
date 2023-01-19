# api-key = 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

read -p "Enter Question:" query

tmux neww bash -c "echo \"curl -X POST -H \"Content-Type: application/json\" -d '{ \"prompt\": \"$query\", \"model\": \"text-davinci-002\", \"api_key\": \"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\" }' \"https://api.openai.com/v1/engines/davinci/completions\" while [ : ]; do sleep1; done"
