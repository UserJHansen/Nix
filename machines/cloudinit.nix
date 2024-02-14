config@{inputs, pkgs, self, withSystem, disko, ...}: {
  flake.nixosConfigurations.cloudinit = withSystem "x86_64-linux" (ctx@{ config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.base
        ./modules/disko.nix
        ({ lib, config, ...}: {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          ];
          boot.loader.grub.device = "/dev/sda";
          disko.devices.disk.base.device = "/dev/sda";

          fileSystems."/" = {
            label = "nixos";
            fsType = "ext4";
            autoResize = true;
            neededForBoot = true;
          };

          services.qemuGuest.enable = true;
          security.sudo.wheelNeedsPassword = false;

          systemd.network.enable = true;
          networking.dhcpcd.enable = false;
          services.cloud-init = {
            enable = true;
            network.enable = true;
            config = ''
              system_info:
                distro: nixos
                network:
                  renderers: [ 'networkd' ]
                default_user:
                  name: userj
              users:
                  - default
              ssh_pwauth: false
              chpasswd:
                expire: false
              cloud_init_modules:
                - migrator
                - seed_random
                - growpart
              cloud_config_modules:
                - disk_setup
                - mounts
                - set-passwords
                - ssh
              cloud_final_modules: []
              '';
          };
        })
      ];
  });

  flake.cloudimage = let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    make-disk-image = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix";
  in make-disk-image {
      inherit pkgs;
      lib = pkgs.lib;
      config = self.nixosConfigurations.cloudinit.config;
      name = "nixos-cloudinit";
      format = "qcow2-compressed";
      copyChannel = false;
    };
}