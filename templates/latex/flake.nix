{
  description = "LaTeX thesis dev shell";

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
            texliveFull   # all engines, all CTAN packages, latexmk, biber, chktex
            texlab        # LSP
            (python3.withPackages (ps: [ ps.pygments ]))   # pygmentize, for minted
            zathura       # SyncTeX viewer
          ];
        };
      });
}
