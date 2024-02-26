{ config, ... }: {
  sops = {
    defaultSopsFile = ./keys.yaml;
    age.sshKeyPaths = [ "/persist/ssh_host_ed25519_key" ];
    secrets = {
      "passwords/userj" = {
        neededForUsers = true;
      };
      "passwords/root" = {
        neededForUsers = true;
      };
    };
  };
}