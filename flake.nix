{
  description = "Ge1dron's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [
        inputs.nvf.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
