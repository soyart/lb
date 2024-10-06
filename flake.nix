rec {
  description = "Prints line in TTY";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;

      # The set of systems to provide outputs for
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });

      meta = {
        inherit description;
        homepage = "https://github.com/soyart/lb";
      };
    in

    {
      packages = forAllSystems ({ pkgs }: {
        # The Go program
        default = pkgs.buildGoModule {
          inherit version meta;

          pname = "yn";
          src = ./.;
          vendorHash = "sha256-ko3hrXEr/QihgyPk6ZYdebicJE4mqlM4RtaG9M3TbLA="; # Use pkgs.lib.fakeHash when updating dependencies
        };
      });

      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell
          {
            packages = with pkgs; [
              file

              nixd
              nixpkgs-fmt

              go
              gopls
              gotools
              go-tools
            ];
          };
      });
    };
}
