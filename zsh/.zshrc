export ZSH="$HOME/.oh-my-zsh"

HOST_NAME=batman
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005f87' # check color map https://upload.wikimedia.org/wikipedia/commons/3/15/Xterm_256color_chart.svg



plugins=(git z zsh-autosuggestions nvm)


for i in `find -L $HOME/.config/zsh_setup`; do
    source $i
done

source $ZSH/oh-my-zsh.sh

eval "$(pyenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Conda: not initialized by default. Run 'conda init zsh' if needed.
# .  $HOME/.sdkman/bin/sdkman-init.sh


# Go Version Manager
# [[ -s "/Users/adam/.gvm/scripts/gvm" ]] && source "/Users/adam/.gvm/scripts/gvm"

# Bun completions
[ -s "/Users/adam/.bun/_bun" ] && source "/Users/adam/.bun/_bun"