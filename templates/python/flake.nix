{
  description = "Python dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python313
            uv      # venv + dependency management
            ruff    # linter + formatter
            pyright # type checker / LSP
          ];

          # Use the Nix interpreter rather than letting uv fetch its own
          # (uv's downloads are dynamically linked and won't run here).
          UV_PYTHON_DOWNLOADS = "never";
        };
      });
}

