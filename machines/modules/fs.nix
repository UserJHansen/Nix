{lib, ...}: {
  fileSystems."/" = {
    fsType = "tmpfs";
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "/dev/pool/persist";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = lib.mkDefault "/dev/disk/by-partlabel/ESP";
    fsType = "vfat";
  };
}