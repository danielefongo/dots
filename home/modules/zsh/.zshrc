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
HISTFILE=~/dots/home/modules/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt histignorespace
setopt histignorealldups

# custom zshrc
if [ -f ~/.custom_zshrc ]; then
  source ~/.custom_zshrc
fi
