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
            plugins = {
              dev.kayovim = {
                pure = ./kayovim;
                impure = "~/dev/personal/kayovim/kayovim";
              };
              start = with pkgs.vimPlugins; [
                lazydev-nvim

                mini-icons
                mini-files
                mini-pick
                mini-statusline
                mini-extra

                blink-cmp
                smear-cursor-nvim

                everforest
                catppuccin-nvim
                nvim-lspconfig
                # nvim-treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                vim-sleuth

                efmls-configs-nvim
              ];
            };
            # plugins = lib.mkMerge [
            #   [
            #     {
            #       dev.kayovim = {
            #         pure = ./kayovim;
            #         impure = "~/dev/personal/kayovim/kayovim";
            #       };
            #     }
            #   ]
            #   (builtins.attrValues {
            #     inherit (pkgs.vimPlugins.nvim-treesitter)
            #       withAllGrammars
            #       ;
            #   })
            #   (builtins.attrValues {
            #     inherit (pkgs.vimPlugins)
            #       lazydev-nvim
            #
            #       mini-icons
            #       mini-files
            #       mini-pick
            #       mini-statusline
            #       mini-extra
            #
            #       blink-cmp
            #       smear-cursor-nvim
            #
            #       everforest
            #       catppuccin-nvim
            #       nvim-lspconfig
            #       nvim-treesitter
            #       nvim-treesitter-textobjects
            #       vim-sleuth
            #
            #       efmls-configs-nvim
            #       ;
            #   })
            # ];
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
