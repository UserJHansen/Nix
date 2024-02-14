{
  config.userList.userj = {
    canLogin = true;
    account = {
      hashedPasswordFile = "/persist/userj.hash";
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };
}