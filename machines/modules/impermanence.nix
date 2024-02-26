{
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/var/log"
    ];
  };
}