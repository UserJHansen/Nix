{ lib, inputs, self, ... }@ctx: {
  flake.nixosModules.base = {
      imports = [
        ./impermanence.nix
        ./../../secrets
        ./../../ssh
        ./../../users
        ({pkgs,...}: {
            programs.git.enable = true;
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }

        inputs.impermanence.nixosModules.impermanence
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
      ];
  };
}