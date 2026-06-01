{
  description = "OS/161 toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        makeOs161Symlinks = ''
          cd $out/bin
          for i in mips-harvard-os161-*; do
            ln -s "$i" "os161-''${i#mips-harvard-os161-}"
          done
        '';
      in
      {
        packages = rec {
          os161-binutils = pkgs.callPackage ./pkgs/os161-binutils.nix { inherit makeOs161Symlinks; };
          os161-gcc = pkgs.callPackage ./pkgs/os161-gcc.nix { inherit os161-binutils makeOs161Symlinks; };
          os161-gdb = pkgs.callPackage ./pkgs/os161-gdb.nix { inherit makeOs161Symlinks; };
          sys161 = pkgs.callPackage ./pkgs/sys161.nix { };

          default = pkgs.symlinkJoin {
            name = "os161-toolchain";
            paths = [
              os161-binutils
              os161-gcc
              os161-gdb
              pkgs.bmake
              sys161
            ];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with self.packages.${system}; [
            os161-binutils
            os161-gcc
            os161-gdb
            pkgs.bmake
            sys161
          ];
        };
      }
    );
}
