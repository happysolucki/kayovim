{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    neovim-nightly = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    # flake-compat = {
    #   type = "github";
    #   owner = "edolstra";
    #   repo = "flake-compat";
    #   flake = false;
    # };
    mnw = {
      type = "github";
      owner = "gerg-l";
      repo = "mnw";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      neovim-nightly,
      mnw,
      systems,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      # inherit (nixpkgs) lib;
    in
    {
      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              self.packages.${system}.default.devMode
              # self.formatter.${system}
              # pkgs.npins
            ];
          };
        }
      );

      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.packages.${system}.neovim;
          neovim = mnw.lib.wrap pkgs {
            inherit (neovim-nightly.packages.${system}) neovim;
            appName = "kayovim";
            desktopEntry = false;
          };

          initLua = ''
            require('kayovim')
          '';

          # Add lua config
          devExcludedPlugins = [
            ./kayovim
          ];

          # Impure path to lua config for devShell
          devPluginPaths = [
            "/home/kayotune/dev/projects/kayovim/kayovim"
          ];
        }
      );
    };
}
