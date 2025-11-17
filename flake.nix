{
  description = "NixOS deploy.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs =
    { self, nixpkgs }:
    let
      forSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      getPkgs = system: import nixpkgs { inherit system; };
    in
    {
      formatter = forSystems (s: (getPkgs s).nixfmt-tree);
      templates.default = {
        path = ./install-nixos;
        description = "NixOS configuration.";
      };
    };
}
