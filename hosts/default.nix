{ lib, ... }: {
  imports = [
    ./t2/web.nix
  ];

  options = {
    terraform = lib.mkOption {
      type = lib.types.attrs;
    };
  };
}