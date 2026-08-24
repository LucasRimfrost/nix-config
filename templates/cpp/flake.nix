{
  description = "C / C++ dev shell";

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
            clang-tools     # clangd + clang-format
            cmake
            gnumake
            gdb
          ];

          # Libraries you LINK against belong in buildInputs, not packages --
          # that is what puts headers and .so files where the compiler looks.
          # buildInputs = with pkgs; [ SDL2 zlib ];

          # clangd needs compile_commands.json. With CMake:
          #   cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
          #   ln -sf build/compile_commands.json .
          # With plain make, use `bear -- make`.
        };
      });
}


