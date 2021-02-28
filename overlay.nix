final: prev: {
  lotusSrc = prev.callPackage ./pkgs/lotus-src.nix { };
  filcrypto = prev.callPackage ./pkgs/filcrypto.nix { };
  filecoin-ffi = prev.callPackage ./pkgs/filecoin-ffi.nix { };
  lotus = prev.callPackage ./pkgs/lotus.nix { };
}
