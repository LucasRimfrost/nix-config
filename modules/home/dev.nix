{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- Python ---
    python3
    uv            # fast venv/dependency manager
    ruff          # linter
    pyright       # LSP (provides pyright-langserver)

    # --- C / C++ ---
    clang-tools   # clangd (LSP) + clang-format
    cmake
    gnumake
    gdb

    # --- Rust (toolchain via Nix, NOT rustup — rustup binaries break on NixOS) ---
    rustc
    cargo
    rust-analyzer # LSP (your lsp.lua calls `rust-analyzer` on PATH)
    clippy
    rustfmt

    # --- Lua ---
    lua
    lua-language-server # lua_ls
    stylua              # formatter

    # --- Java ---
    jdk21
    maven
    jdt-language-server # provides the `jdtls` wrapper used by nvim-jdtls

    # --- LaTeX ---
    # texliveFull   # full TeX distribution: latex, latexmk, latexindent, biber, all packages
    texlab        # LaTeX LSP

    # --- General ---
    git
    nodejs        # for nvim plugins / some LSPs (no nvm on NixOS)
  ];

  # All LSP servers and formatters your Neovim config references now live on
  # PATH via the packages above, which is why Mason is removed from the nvim
  # config (Mason's downloaded binaries don't run on NixOS).
}
