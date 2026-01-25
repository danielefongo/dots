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
export NIX_REMOTE=daemon

eval "$(sheldon source)"

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt extended_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_verify
setopt hist_reduce_blanks

# custom zshrc
if [ -f ~/.custom_zshrc ]; then
  source ~/.custom_zshrc
fi
