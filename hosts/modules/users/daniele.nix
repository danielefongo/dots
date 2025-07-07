{ user_data, ... }:

{
  users.users."${user_data.user}" = {
    isNormalUser = true;
    description = user_data.user;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "users"
    ];
  };

  home-manager = {
    users."${user_data.user}" = import ../../../home/daniele.nix;
    backupFileExtension = "hm-bak";
  };
}
