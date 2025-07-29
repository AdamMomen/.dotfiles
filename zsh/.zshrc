export ZSH="$HOME/.oh-my-zsh"

HOST_NAME=batman
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005f87' # check color map https://upload.wikimedia.org/wikipedia/commons/3/15/Xterm_256color_chart.svg


plugins=(git zsh-z zsh-autosuggestions zsh-nvm zsh_codex)

bindkey ^X create_completion
# history-substring-search zsh-syntax-highlighting
# TODO Test the zsh-autosuggestions plugin and see if it makes me a better developer...

source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile

export PYENV_ROOT="$HOME/.pyenv"
path+=("$HOME/bin")
path+=("/opt/homebrew/opt/go@1.18/bin")
path+=("/opt/homebrew/anaconda3/bin")
path+=("/opt/homebrew/opt/libpq/bin")
# path+=("/Users/adam/.local/share/bob/nvim-bin")
export PATH

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/adam/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adam/tools/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/Users/adam/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adam/tools/google-cloud-sdk/completion.zsh.inc'; fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# [[ -s "/home/adam/.sdkman/bin/sdkman-init.sh" ]] && source "/home/adam/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#Uncomment below for conda setup
function init_conda() {
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
}
# <<< conda initialize <<<
# .  $HOME/.sdkman/bin/sdkman-init.sh


export EDITOR="/usr/bin/vi"
export VISUAL="/usr/bin/vi"
