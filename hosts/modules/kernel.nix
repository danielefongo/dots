{ ... }:

{
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "amdgpu"
    ];
    kernelModules = [ "amdgpu" ];
  };

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModprobeConfig = ''
    options amdgpu dc=1
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  t
}
