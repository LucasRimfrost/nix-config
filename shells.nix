{ pkgs }:

{
  rust = pkgs.mkShell {
    packages = with pkgs; [
      rustc
      cargo
      clippy
      rustfmt
      rust-analyzer
    ];
    # Without this rust-analyzer cannot resolve stdlib symbols - the most
    # common "go-to-definition is broken on NixOS" complaint.
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  python = pkgs.mkShell {
    packages = with pkgs; [
      python3
      uv        # venv / dependency manager
      ruff      # linter + formatter
      pyright   # LSP
    ];
  };

  cpp = pkgs.mkShell {
    packages = with pkgs; [
      clang-tools   # clangd + clang-format
      cmake
      gnumake
      gdb
    ];
  };

  java = pkgs.mkShell {
    packages = with pkgs; [
      jdk21
      maven
      jdt-language-server   # provides the `jdtls` wrapper
    ];
  };
}
