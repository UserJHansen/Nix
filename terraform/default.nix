{ pkgs, inputs, self, config, lib, ... }: {
    flake.defaultPackage."x86_64-linux" = inputs.terranix.lib.terranixConfiguration {
      system = "x86_64-linux";
      modules = [
        config.terraform
      ];
    };
  }