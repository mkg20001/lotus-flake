{
  description = "Lotus Daemon (filecoin) flake";

  outputs = { self, nixpkgs }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in

    {
      overlay = import ./overlay.nix;

      defaultPackage = forAllSystems (
        system: (
          import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          }
        ).lotus
      );

      packages = forAllSystems (
        system: (
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlay ];
            };
          in
          {
            lotus = pkgs.lotus;
            filcrypto = pkgs.filcrypto;
            filecoin-ffi = pkgs.filecoin-ffi;
          }
        )
      );

      nixosModules.lotus = import ./module.nix;

    };
}
