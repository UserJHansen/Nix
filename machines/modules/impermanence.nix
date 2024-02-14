{
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/log"
      # "/var/lib/bluetooth"
      # "/var/lib/docker"
      "/etc/ssh/"
    ];
  };
  
  fileSystems."/persist".neededForBoot = true;
}