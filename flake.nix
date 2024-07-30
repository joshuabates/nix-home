{
  description = "Personal dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations =
    let
      mkDarwinWorkstation = username: name: system: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = attrs // { inherit username; };
        modules = [
          ({ config, pkgs, ... }: {
            users.users.${username} = {
              name = username;
              home = "/Users/${username}";
            };
          })
          ./modules/common
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = [ 
                ./modules/home/common.nix
                ./modules/home/darwin.nix
              ];
            };
          }
        ];
      };
    in
    {
      m3-slate = mkDarwinWorkstation "joshuabates" "m3-slate" "aarch64-darwin";
      studio = mkDarwinWorkstation "joshua" "studio" "aarch64-darwin";
    };

    nixosConfigurations = 
    let
      mkNixOSWorkstation = username: name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./modules/common
          ./modules/linux
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = { 
                imports = [ 
                  ./modules/home/common.nix
                  ./modules/home/linux.nix
                ];
              };
            };
          }
        ];
      };
    in
    {
      # Add your NixOS configurations here
      # example-nixos = mkNixOSWorkstation "username" "hostname" "x86_64-linux";
    };
  };
}
