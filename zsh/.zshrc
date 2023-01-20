export ZSH="$HOME/.oh-my-zsh"

HOST_NAME=batman
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005f87' # check color map https://upload.wikimedia.org/wikipedia/commons/3/15/Xterm_256color_chart.svg



plugins=(git zsh-z zsh-autosuggestions zsh-nvm web-search)
# history-substring-search zsh-syntax-highlighting
# TODO Test the zsh-autosuggestions plugin and see if it makes me a better developer...

source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile

path+=("$HOME/bin")
path+=("/opt/homebrew/opt/go@1.18/bin")
path+=("/opt/homebrew/opt/libpq/bin")
export PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/adam/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adam/tools/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/Users/adam/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adam/tools/google-cloud-sdk/completion.zsh.inc'; fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# [[ -s "/home/adam/.sdkman/bin/sdkman-init.sh" ]] && source "/home/adam/.sdkman/bin/sdkman-init.sh"
