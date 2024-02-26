config@{inputs, pkgs, self, withSystem, disko, ...}: {
  flake.nixosConfigurations.simple = withSystem "x86_64-linux" (ctx@{ config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.base
        ./modules/disko.nix
        ./modules/fs.nix
        ./modules/impermanence.nix
        ({ lib, config, ...}: {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          ];

          disko.devices.disk.base.device = "/dev/sda";
          boot.loader.systemd-boot.enable = true;

          services.qemuGuest.enable = true;
          security.sudo.wheelNeedsPassword = false;

          systemd.network.enable = true;
          networking.useNetworkd = true;
          networking.hostName = "servervm";
        })
      ];
  });

  flake.deploy.nodes.servervm = {
    hostname = "servervm";
    
    profiles.system = {
      sshUser = "root";
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.simple;
    };
  };
}