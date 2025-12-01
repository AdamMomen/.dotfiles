export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005f87' # check color map https://upload.wikimedia.org/wikipedia/commons/3/15/Xterm_256color_chart.svg



plugins=(git z zsh-autosuggestions nvm)


for i in `find -L $HOME/.config/zsh_setup`; do
    source $i
done

source $ZSH/oh-my-zsh.sh

eval "$(pyenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


bindkey -s ^f "tmux-sessionizer\n"

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
  # Set the prompt for SSH sessions
  HOST_NAME=batman
  export PS1="%n@$HOST_NAME:%~%# "
fi



# Conda: not initialized by default. Run 'conda init zsh' if needed.
# .  $HOME/.sdkman/bin/sdkman-init.sh


# Go Version Manager
# [[ -s "/Users/adam/.gvm/scripts/gvm" ]] && source "/Users/adam/.gvm/scripts/gvm"

# Bun completions
[ -s "/Users/adam/.bun/_bun" ] && source "/Users/adam/.bun/_bun"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
eval "$(rbenv init - zsh)"
