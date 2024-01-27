{
  services.openssh.enable = true;
  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "/persist/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    (import ../wellknown).sshPublic
  ];
}