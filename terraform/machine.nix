{
  terraformLocal = { hostname }: {
    "deploy-${hostname}" = {
      source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one";
      nixos_system_attr = "${toString ./..}#nixosConfigurations.${hostname}.config.system.build.toplevel";
      nixos_partitioner_attr = "${toString ./..}#nixosConfigurations.${hostname}.config.system.build.diskoScript";

      target_host = hostname;
      instance_id = hostname;
    };
  };
}