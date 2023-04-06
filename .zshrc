# antigen
source "$HOME/dotfiles/dots/antigen/antigen.zsh"
antigen use oh-my-zsh
antigen bundle asdf-vm/asdf
antigen bundle git
antigen bundle scmbreeze/scm_breeze
antigen bundle autojump
antigen bundle fzf
antigen bundle danielefongo/shapeshift
antigen apply

# asdf
source "$HOME/dotfiles/dots/asdf/asdf.sh"

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt histignoredups

# fzf
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

# kitty
pid=$$
KITTY_THEME_FILE=~/dotfiles/dots/kitty/colors.conf
last_theme_update() {
  stat -c %Y $KITTY_THEME_FILE
}
theme_watcher() {
  LAST_THEME_UPDATE=$(last_theme_update)
  while true; do
    edit_time=$(last_theme_update)
    if [[ $LAST_THEME_UPDATE -lt $edit_time ]]; then
      kill -USR1 $pid
      LAST_THEME_UPDATE=$(last_theme_update)
    fi
    sleep 0.5
  done
}
theme_watcher &!
TRAPUSR1() {
  kitty @ set-colors --all --configured $KITTY_THEME_FILE > /dev/null;
}

# others
if [ -f ~/.custom_zshrc.sh ]; then
  source ~/.custom_zshrc.sh
fi
