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

  programs.ssh = {
    enable = true;
  };

  home.persistence."/persist/home/userj".directories = [".ssh"];

  config.users.users.root.openssh.authorizedKeys.keys = [
    (import ../wellknown).sshPublic
  ];

  home.activation.copySSHKey = dagEntryAfter ["writeBoundary"] ''
      install -D -m600 ${./../private/id_rsa} $HOME/.ssh/id_rsa
  '';
}