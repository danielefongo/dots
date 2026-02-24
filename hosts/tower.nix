args@{
  inputs,
  pkgs,
  lib,
  config,
  user,
  ...
}:

let
  mods = import ../mod args;

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
    (mods.home user {
      mod.home.apps.audio.enable = true;
      mod.home.apps.chat.enable = true;
      mod.home.apps.copyq.enable = true;
      mod.home.apps.firefox.enable = true;
      mod.home.apps.onepassword.enable = true;
      # mod.home.apps.peek.enable = true;
      mod.home.apps.qalculate.enable = true;
      mod.home.apps.spotify.enable = true;
      mod.home.apps.steam.enable = true;
      mod.home.apps.yazi.enable = true;
      mod.home.apps.xnviewmp.enable = true;

      mod.home.cli.enable = true;

      mod.home.desktop.wayland.enable = true;
      mod.home.desktop.rofi.enable = true;

      mod.home.editor.enable = true;
      mod.home.shell.enable = true;
      mod.home.system.enable = true;
      mod.home.terminal.enable = true;
    })
    (mods.host user hardware {
      mod.host.base.enable = true;
      mod.host.bluetooth.enable = true;
      mod.host.docker.enable = lib.hasHomeModule config "cli.docker";
      mod.host.i3.enable = lib.hasHomeModule config "desktop.i3";
      mod.host.niri.enable = lib.hasHomeModule config "desktop.niri";
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
