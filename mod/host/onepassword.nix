{ lib, user, ... }:

lib.hostOpts.module "onepassword" { } (_: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user.name ];
  };

  security.pam.services."1password".enableGnomeKeyring = true;
})
