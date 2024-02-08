{ terranix, pkgs, system, lib, ... }: let
    terraform = pkgs.terraform.withPlugins (ps: with ps; [
          aws
          external
          ps.null
          local
        ]);

    terraformConfiguration = terranix.lib.terranixConfiguration {inherit system;} // terraform;
    
    # https://github.com/nix-community/dream2nix/blob/936208ae7d88a178a0bcf7e6ac21bb6b87f6c8ea/modules/flake-parts/apps.update-locks.nix#L41C1-L45C7
    toApp = script: {
      type = "app";
      program = "${script}";
    };
    
    apply = pkgs.writers.writeBash "apply" ''
        if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
        cp ${terraformConfiguration} config.tf.json \
          && ${terraform}/bin/terraform init \
          && ${terraform}/bin/terraform apply
      '';
    destroy = pkgs.writeShellScript "destroy" ''
        if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
        cp ${terraformConfiguration} config.tf.json \
          && ${terraform}/bin/terraform init \
          && ${terraform}/bin/terraform destroy
      '';
  in {
    apps.terraform = lib.mapAttrs (_: toApp) {
        inherit apply destroy;
      };
  }