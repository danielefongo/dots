# antigen
source "$HOME/dotfiles/dots/antigen/antigen.zsh"
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