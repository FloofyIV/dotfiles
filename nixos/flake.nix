{
  description = "nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stablepkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, helium, ... }@inputs:
    {
    nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
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
