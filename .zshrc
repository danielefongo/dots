# antigen
source "$HOME/dotfiles/dots/antigen/antigen.zsh"
antigen bundle git
antigen bundle autojump
antigen bundle fzf
antigen bundle danielefongo/shapeshift
antigen apply

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt histignoredups