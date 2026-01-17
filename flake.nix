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

  outputs = { self, darwin, home-manager, nixpkgs }: {
    supportedSystems = ["aarch64-darwin"];
    darwinConfigurations =
    let
      mkDarwinWorkstation = username: uid: name: system: darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: {
            users.knownUsers = [ username ];
            users.users.${username} = {
              name = username;
              home = "/Users/${username}";
              shell = pkgs.fish;
              uid = uid;
            };
          })
          ./modules/common.nix
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
      jbatesm3-mbp16 = mkDarwinWorkstation "joshuabates" 501 "jbatesm3-mbp16" "aarch64-darwin";
      studio = mkDarwinWorkstation "joshua" 501 "studio" "aarch64-darwin";
      mb14 = mkDarwinWorkstation "joshua" 503 "mb14" "aarch64-darwin";
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
      # example-nixos = mkNixOSWorkstation "username" "hostname" "x86_64-linux";
    };
  };
}
