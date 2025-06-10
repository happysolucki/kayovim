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
      inherit (nixpkgs) lib;
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
            initLua = ''
              require('kayovim')
            '';
            devExcludedPlugins = [
              ./kayovim
            ];
            devPluginPaths = [
              # This normally should be a absolute path
              # here it'll only work from this directory
              "~/dev/projects/kayovim/kayovim"
            ];
            plugins = lib.mkMerge [
              [
                {
                  name = "jellybeans-nvim";

                  src = pkgs.fetchFromGitHub {
                    owner = "WTFox";
                    repo = "jellybeans.nvim";
                    rev = "66ff0d401a1ac14d70527f8a2f0d7ecc739ec245";
                    hash = "sha256-NQc5ddFHe5Kw3FuKAEdkYzuvktK/Dnv0SXsWr1JeXXU=";
                  };

                  dependencies = [ ];
                }
              ]
              (builtins.attrValues {
                inherit (pkgs.vimPlugins.nvim-treesitter)
                  withAllGrammars
                  ;
              })
              (builtins.attrValues {
                inherit (pkgs.vimPlugins)
                  lazydev-nvim

                  blink-cmp
                  smear-cursor-nvim

                  fzf-lua
                  oil-nvim
                  everforest
                  nvim-lspconfig
                  nvim-treesitter
                  nvim-treesitter-context
                  nvim-treesitter-textobjects
                  vim-sleuth

                  efmls-configs-nvim
                  ;
              })
            ];
            extraBinPath = builtins.attrValues {
              inherit (pkgs)
                lua-language-server
                vscode-langservers-extracted
                efm-langserver
                stylua
                nixfmt-rfc-style
                nixd
                statix
                vtsls

                fzf
                ;
            };
          };
        }
      );
    };
}
