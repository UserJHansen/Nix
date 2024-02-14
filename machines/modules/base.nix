{ lib, pkgs, moduleWithSystem, inputs, ... }@ctx: {
  flake.nixosModules.base = {
      imports = [
        ./impermanence.nix
        ./../../users
        ({
            programs.git.enable = true;
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            swapDevices = [{
                device = "/dev/pool/swap";
              }
            ];

            boot.loader = {
              systemd-boot = {
                enable = lib.mkDefault false;
              };

              efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
              };
            };

            system.stateVersion = "24.05";
        })

        inputs.impermanence.nixosModules.impermanence
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
      ];
  };
}