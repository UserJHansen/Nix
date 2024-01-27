let
  mc = import ./machine.nix;
in
with mc;
{
  module = terraformLocal {
      hostname = "nixos-laptop";
    };
}