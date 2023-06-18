{
  description = "Pearsche's home-manager setup.";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."pearsche" = home-manager.lib.homeManagerConfiguration {
        # https://github.com/nix-community/home-manager/issues/2942
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          ./fonts.nix
          ./home.nix
		      ./nixpkgs.nix
		      ./programs.nix
		      ./qt.nix
		      ./services.nix 
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
