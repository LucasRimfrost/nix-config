{ config, pkgs, ... }:
{
  # Rule for what belongs here vs. in a devShell:
  #
  #  Global -> anything Neovim needs to function no matter where you are,
  #            and any LSP that does NOT depend on a project toolchain.
  #  devShell -> compilers, runtimes, and every LSP that shells out to one
  #              (rust-analyzer -> cargo, pyright -> venv, clangd -> stdlib,
  #              jdtls -> jdk). Version skew there causes real bugs.

  home.packages = with pkgs; [
    neovim

    # --- Pickers / search (mini.pick + shell aliases)
    ripgrep      # fzf-lua grep, your `grep` alias
    fd           # fzf-lua files, your `find` alias

    # --- Treesitter ---
    # nvim-treesitter on `main` compiles parsers at runtime, so the CLI and a
    # C compiler must always be present, even though C itself is a devShell lang.
    tree-sitter  # nvim-treesitter parser compilation
    gnumake
    gcc          # compiles treesitter parsers at runtime (:TSInstall)

    # --- Toolchain-agnostic LSPs + formatters ---
    lua-language-server     # lua_ls: nvim config, anywhere
    stylua
    nixd                    # I edit .nix constantly; this repo included
    nixfmt                  # provides the `nixfmt` binary nixd calls

    # --- General ---
    unzip
    wget
    curl
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Lucas Rimfrost";
        email = "lucas.rimfrost@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
  };

  home.sessionVariables.EDITOR = "nvim";

  # Live symlink, not a store copy: edits to dotfiles/nvim take effect
  # immediately with no `nixos-rebuild switch` in between.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/dotfiles/nvim";
}
