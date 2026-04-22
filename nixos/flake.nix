{
  description = "nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, helium, ... }@inputs:
    {
    nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
    };
    inherit inputs;
  };

  modules = [
    ({ ... }: {
      nixpkgs.config = {
        allowUnfree = true;
      };
    })

    ./configuration.nix

    home-manager.nixosModules.home-manager

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.floofy = import ./home.nix;

        extraSpecialArgs = {
          inherit inputs;
        };
        backupFileExtension = "backup";
      };
    }
  ];
};
 };
}
