{lib, pkgs, config, ...}: {
  imports = [
    ./userj.nix
  ];

  options = {
    userList = lib.mkOption {
      type = lib.types.attrs;
    };
  };

  config = {
    userList.dummy.canLogin = false;

    programs.zsh.enable = true;
    users = {
      defaultUserShell = pkgs.zsh;

      mutableUsers = false;

      users = lib.attrsets.mapAttrs (name: value: value.account) (lib.attrsets.filterAttrs (name: value: value.canLogin) config.userList);
    };
  };
}