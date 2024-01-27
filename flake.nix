{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    
    inputs.deploy-rs.url = "github:serokell/deploy-rs";
    
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, impermanence, deploy-rs, flake-utils, terranix, disko }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };
        terraform = pkgs.terraform.withPlugins (ps: with ps; [
          aws
          external
          ps.null
          local
        ]);
        terraformConfiguration = terranix.lib.terranixConfiguration {
          inherit system;
          modules = [ ./terraform ];
        };
      in
      {
        defaultPackage = terraformConfiguration;

        # nix develop
        devShell = pkgs.mkShell {
          buildInputs = [
            terraform
            terranix.defaultPackage.${system}
          ];
        };
        # nix run ".#apply"
        apps.apply = {
          type = "app";
          program = toString (pkgs.writers.writeBash "apply" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration} config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform apply
          '');
        };
        # nix run ".#destroy"
        apps.destroy = {
          type = "app";
          program = toString (pkgs.writers.writeBash "destroy" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration} config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform destroy
          '');
        };
        # nix run
        defaultApp = self.apps.${system}.apply;

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
        })//(
        let
          x86_pkgs = import nixpkgs {
            config.allowUnfree = true;
            system = "x86_64-linux";
            overlays = [
              deploy-rs.overlay
              (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
            ];
          };
          x86_base = import ./machines {
            inherit nixpkgs;
            inherit impermanence;
            pkgs = x86_pkgs;
          };
          
          aarch64_pkgs = import nixpkgs {
            config.allowUnfree = true;
            system = "aarch64-linux";
            
            overlays = [
              deploy-rs.overlay
              (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
            ];
          };
          aarch64_base = import ./machines {
            inherit nixpkgs;
            inherit impermanence;
            pkgs = aarch64_pkgs;
            };
        in
        {
          nixosConfigurations = {
            nixos-laptop = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";

              modules = [
                disko.nixosModules.disko
                impermanence.nixosModules.impermanence
                x86_base
              ];
            };
          };
          deploy.nodes.nixos-laptop.profiles.system = {
              user = "root";
              path = x86_pkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.nixos-laptop;
          };
      });
}
