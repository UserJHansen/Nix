config: {
  config.services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/persist/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  config.users.users.root.openssh.authorizedKeys.keys = [
    (import ../wellknown).sshPublic
  ];
}