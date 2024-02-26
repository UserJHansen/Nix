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
}