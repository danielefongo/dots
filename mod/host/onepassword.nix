{ lib, user_data, ... }:

lib.hostOpts.module "onepassword" { } (_: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user_data.user ];
  };

  security.pam.services."1password".enableGnomeKeyring = true;
})
