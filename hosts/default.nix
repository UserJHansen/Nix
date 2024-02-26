{ lib, ... }: {
  imports = [
    ./proxmox.nix
    ./../private/proxmox-provider.nix
    ./proxmox/test.nix
  ];

  options = {
    terraform = lib.mkOption {
      type = lib.types.attrs;
    };
  };
}