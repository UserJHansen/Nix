{ nixpkgs, pkgs, impermanence, ... }@inputs:
let
ssh = import ../ssh;
users = import ../users {
  inherit nixpkgs;
  lib = nixpkgs.lib;
  inherit pkgs;
};
in
{
  disko.devices = {
    disk.base = {
      device = nixpkgs.lib.mkDefault "/dev/sda";
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
          swap = {
            name = "swap";
            size = "4G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          root = {
            name = "root";
            size = "20%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
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
          nix = {
            name = "nix";
            size = "100%FREE";
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


  fileSystems."/" = {
    device = "/dev/pool/root";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "/dev/pool/persist";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = nixpkgs.lib.mkDefault "/dev/disk/by-partlabel/ESP";
    fsType = "vfat";
  };

  swapDevices = [{
      device = "/dev/pool/swap";
    }
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.initrd.postDeviceCommands = ''
    echo wiping root device...
    mkdir /tmp/root
    ${pkgs.util-linux}/bin/mount /dev/pool/root /tmp/root
    rm -rf /tmp/root/*
    ${pkgs.util-linux}/bin/umount /tmp/root
  '';

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/etc/ssh/"
    ];
  };

  system.stateVersion = "24.05";
}//ssh//users