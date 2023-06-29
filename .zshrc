# antigen
if ! [ -f "$HOME/antigen.zsh" ]; then
  curl -L git.io/antigen -s > "$HOME/antigen.zsh"
fi
source "$HOME/antigen.zsh"

antigen use oh-my-zsh
antigen bundle asdf-vm/asdf
antigen bundle git
antigen bundle scmbreeze/scm_breeze
antigen bundle autojump
antigen bundle fzf
antigen bundle danielefongo/shapeshift
antigen apply

# asdf
asdf_install_all() {
  cat ~/.tool-versions | cut -f1 -d' ' | grep -ve '^$' | while read package; do
    asdf plugin add $package
  done
  asdf install
}

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

# others
if [ -f ~/.custom_zshrc.sh ]; then
  source ~/.custom_zshrc.sh
fi

command -v tmux >/dev/null && case "${TERM_PROGRAM}" in
  "tmux") ;;
  *)
    session_name="workspace"
    tmux new -s "${session_name}"
    tmux attach -t "${session_name}"
    ;;
esac
