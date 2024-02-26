{ pkgs, home-manager, ... }: 
with import <nixpkgs> {};
with builtins;
with lib;
with import <home-manager/modules/lib/dag.nix> { inherit lib; };
 {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };
    environment.shells = with pkgs; [ zsh ];
  
    programs.home-manager.enable = true;
    home-manager.users.userj = {
      home.stateVersion = "18.09";
    }

    programs.git = {
      enable = true;
      userName = "UserJHansen";
      userEmail = "47265397+UserJHansen@users.noreply.github.com";
    }

    programs.command-not-found.enable = true;
    home.packages = [
      pkgs.unzip
      pkgs.wget
      pkgs.htop
      pkgs.ncdu # Disk space usage analyzer
      pkgs.neofetch
      pkgs.file
      coreutils
    ];

    home.activation.copySSHKey = dagEntryAfter ["writeBoundary"] ''
        install -D -m600 ${./private/id_rsa} $HOME/.ssh/id_rsa
    '';
}