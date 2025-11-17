{
  description = "NixOS install.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      nixos-facter-modules,
    }:
    let
      hostName = "nixos";
      userName = "nixos";
      forSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      getPkgs = system: import nixpkgs { inherit system; };
    in
    {
      formatter = forSystems (s: (getPkgs s).nixfmt-tree);

      templates = {
        btrfs = {
          path = ./disko/btrfs;
          description = "Single disk configuration with Btrfs.";
        };

        luks-btrfs-nvme = {
          path = ./disko/btrfs-luks-nvme;
          description = "Single disk configuration with Btrfs, LUKS encryption and NVMe mount options.";
        };

        default = self.templates.btrfs;
      };

      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit hostName userName; };
        modules = [
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./facter.json; }

          disko.nixosModules.disko
          ./disko.nix

          {
            networking.hostName = hostName;

            users.users.${userName} = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "nixos";
            };

            security.sudo.extraRules = [
              {
                users = [ userName ];
                commands = [
                  {
                    command = "ALL";
                    options = [
                      "NOPASSWD"
                      "SETENV"
                    ];
                  }
                ];
              }
            ];

            boot.loader.limine.enable = true; # support SecureBoot (see docs for setup)
            zramSwap.enable = true; # in-memory compressed swap (can use 50% of RAM by default)

            services.openssh.enable = true;
            programs.git.enable = true;

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            system.stateVersion = "25.11";
          }
        ];
      };
    };
}
