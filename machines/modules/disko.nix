{ lib, ...}: {
  disko.devices = {
    disk.base = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "nofail" ];
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          persist = {
            name = "persist";
            size = "20%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/persist";
              mountOptions = [
                "defaults"
              ];
            };
          };
          swap = {
            name = "swap";
            size = "40%FREE";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          
          nix = {
            name = "nix";
            size = "40%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}