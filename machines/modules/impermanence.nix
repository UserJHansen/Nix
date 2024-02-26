{ impermanence, ... }: {
  imports = [
    impermanence.nixosModules.home-manager.impermanence
  ]

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/log"
    ];
  };
}