# xdg
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi
if [ -d $HOME/.nix-profile/share/zsh/site-functions ]; then
  fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
fi

# antigen
if ! [ -f "$HOME/antigen.zsh" ]; then
  curl -L git.io/antigen -s > "$HOME/antigen.zsh"
fi
source "$HOME/antigen.zsh"

antigen use oh-my-zsh
antigen bundle git
antigen bundle scmbreeze/scm_breeze
antigen bundle fzf
antigen bundle danielefongo/shapeshift
antigen apply

# zoxide
eval "$(zoxide init zsh)"
alias j=z

# direnv
eval "$(direnv hook zsh)"

# history
HISTFILE=~/dots/modules/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt histignoredups

# sesh
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -i | fzf --ansi)
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}
zle -N sesh-sessions
bindkey '^[s' sesh-sessions

# fzf
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

# others
if [ -f ~/.custom_zshrc ]; then
  source ~/.custom_zshrc
fi

local zsh_reload() {
  new_zshrc_md5=$(md5sum ~/.zshrc)
  if [[ "$new_zshrc_md5" != "$actual_zshrc_md5" && -n "$actual_zshrc_md5" ]]; then
    source ~/.zshrc
  fi
  actual_zshrc_md5=$(md5sum ~/.zshrc)
}
SHAPESHIFT_PRECMD=zsh_reload
