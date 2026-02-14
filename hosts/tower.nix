input@{
  inputs,
  pkgs,
  lib,
  config,
  user_data,
  ...
}:

let
  configurations = import ./configurations.nix input;

  hardware = {
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "uas"
      "usbhid"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    networking.hostName = "tower";

    services.printing.enable = true;
  };
in
{
  imports = [
    (configurations.home user_data {
      mod.home.apps.audio.enable = true;
      mod.home.apps.chat.enable = true;
      mod.home.apps.copyq.enable = true;
      mod.home.apps.firefox.enable = true;
      mod.home.apps.ocr.enable = true;
      mod.home.apps.onepassword.enable = true;
      mod.home.apps.peek.enable = true;
      mod.home.apps.qalculate.enable = true;
      mod.home.apps.spotify.enable = true;
      mod.home.apps.steam.enable = true;
      mod.home.apps.thunar.enable = true;
      mod.home.apps.xnviewmp.enable = true;

      mod.home.cli.enable = true;

      mod.home.desktop.x11.enable = true;
      mod.home.desktop.rofi.enable = true;

      mod.home.editor.enable = true;
      mod.home.shell.enable = true;
      mod.home.system.enable = true;
      mod.home.terminal.enable = true;
    })
    (configurations.host user_data hardware {
      mod.host.base.enable = true;
      mod.host.bluetooth.enable = true;
      mod.host.docker.enable = lib.hasHomeModule config "cli.docker";
      mod.host.i3.enable = lib.hasHomeModule config "desktop.i3";
      mod.host.keyboard.enable = true;
      mod.host.linking.enable = true;
      mod.host.networking.enable = true;
      mod.host.onepassword.enable = lib.hasHomeModule config "apps.onepassword";
      mod.host.sound.enable = lib.hasHomeModule config "apps.audio";
      mod.host.steam.enable = lib.hasHomeModule config "apps.steam";
      mod.host.yubikey.enable = lib.hasHomeModule config "cli.yubikey";
    })
  ];
}
