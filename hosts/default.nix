{ lib, ... }: {
  imports = [
    ./proxmox.nix
    ./proxmox/provider.nix
    ./proxmox/test.nix
  ];

  options = {
    terraform = lib.mkOption {
      type = lib.types.attrs;
    };
  };
}