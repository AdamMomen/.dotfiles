export ZSH="$HOME/.oh-my-zsh"

HOST_NAME=batman
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005f87' # check color map https://upload.wikimedia.org/wikipedia/commons/3/15/Xterm_256color_chart.svg



plugins=(git zsh-z zsh-autosuggestions zsh-nvm)
# history-substring-search zsh-syntax-highlighting
# TODO Test the zsh-autosuggestions plugin and see if it makes me a better developer...

source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile

export PYENV_ROOT="$HOME/.pyenv"
path+=("$HOME/bin")
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
# .  $HOME/.sdkman/bin/sdkman-init.sh


export EDITOR="nvim"
export VISUAL="nvim"
[[ -s "/Users/adam/.gvm/scripts/gvm" ]] && source "/Users/adam/.gvm/scripts/gvm"
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/adam/.bun/_bun" ] && source "/Users/adam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
