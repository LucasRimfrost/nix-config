{
  description = "Lucas's NixOS config — ThinkPad X1 Yoga 3rd Gen (20LGS07H00)";

  inputs = {
    # Pinned to the current stable release for maximum stability.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # Make home-manager use the exact same nixpkgs as the system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sensible hardware defaults (Intel CPU, laptop, SSD).
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.lucas = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/lucas

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.lucas = import ./home/lucas.nix;
            # Keep a timestamped backup if a file would be overwritten.
            home-manager.backupFileExtension = "hm-bak";
          }
        ];
      };
    };
}
