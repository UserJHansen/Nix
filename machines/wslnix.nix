config@{inputs, pkgs, self, withSystem, disko, ...}: {
  flake.nixosConfigurations.wslnix = withSystem "x86_64-linux" (ctx@{ config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.base
        inputs.nixos-wsl.nixosModules.wsl
        ({ lib, config, ...}: {
          nixpkgs.hostPlatform = "x86_64-linux";

          wsl.enable = true;

          disko.devices.disk.base.device = "/dev/sdd";
        })
      ];
  });
}