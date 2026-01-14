{ pkgs, ... }:

{
  services.pcscd = {
    enable = true;
    plugins = [ pkgs.ccid ];
  };

  security.pam.services = {
    login.u2fAuth = true;

    sudo.text = ''
      auth       sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=/etc/u2f_keys
      auth       required   pam_unix.so
      account    required   pam_unix.so
      password   required   pam_unix.so
      session    required   pam_unix.so
    '';
  };
}
