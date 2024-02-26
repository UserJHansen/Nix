{ config, ... }: {
  config.nix.settings.trusted-users = ["userj"  "root"];
  config.userList.userj = {
    canLogin = true;
    account = {
      hashedPasswordFile = config.sops.secrets."passwords/userj".path;
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };
}