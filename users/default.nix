{lib, pkgs, ...}:
let
userList = {
  userj = import ./userj.nix;
  dummy.canLogin = false;
};
in
{
  users = {
    defaultUserShell = pkgs.zsh;

    mutableUsers = false;

    users = lib.attrsets.mapAttrs (name: value: value.account) (lib.attrsets.filterAttrs (name: value: value.canLogin) userList);
  };
  
  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
}