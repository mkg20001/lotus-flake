{ fetchFromGitHub
, lotusSrc
, buildGoModule
, pkg-config
, go-rice
, filecoin-ffi
, filcrypto
, lib
}:
let
  ipsnsecp = fetchFromGitHub {
    owner = "ipsn";
    repo = "go-secp256k1";
    rev = "9d62b9f0bc52d16160f79bfb84b2bbf0f6276b03";
    sha256 = "P0DVsWbuQ2BrHGX3eVvM0ucn9YM4XgP1j5vqNDhukr4=";
    fetchSubmodules = true;
  };

  hidlib = fetchFromGitHub {
    owner = "zondax";
    repo = "hid";
    rev = "302fd402163c34626286195dfa9adac758334acc";
    sha256 = "cGJobeveSyJfWDDPBtU2RvnwbwdkvZa2+Nagtoh11/I=";
    fetchSubmodules = true;
  };
in

buildGoModule {
  pname = "lotus";
  version = "0.0.0";

  src = lotusSrc;

  doCheck = false;

  vendorSha256 = "sha256-et+ijsPcAEzo/Cr6bP1hz/GLnRNmJZb4uBeyHK9ySdg=";

  subPackages = [
    "cmd/lotus*"
  ];

  nativeBuildInputs = [
    pkg-config
    go-rice
  ];

  buildInputs = [
    filecoin-ffi
  ] ++ filcrypto.buildInputs;

  preBuild = ''
    if [ -e /build/source/vendor ]; then # only run when vendor got pulled, not before
      chmod +w /build/source/vendor/github.com/ipsn/go-secp256k1
      cp -r ${ipsnsecp}/libsecp256k1 /build/source/vendor/github.com/ipsn/go-secp256k1/libsecp256k1
      chmod +w  /build/source/vendor/github.com/zondax/hid/
      cp -r ${hidlib}/{libusb,hidapi} /build/source/vendor/github.com/zondax/hid/

      chmod +w /build/source/vendor/github.com/filecoin-project/filecoin-ffi/
      find ${filcrypto} -type f -exec ln -s {} /build/source/vendor/github.com/filecoin-project/filecoin-ffi/ \;
    fi
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions/
    install -C ./scripts/bash-completion/lotus $out/share/bash-completion/completions/lotus
    install -C ./scripts/zsh-completion/lotus $out/share/zsh/site-functions/_lotus
  '';

  postFixup = ''
    for l in $out/bin/lotus*; do
      rice append --verbose --exec "$l" -i ./build
    done
  '';

  # preBuild = ''
  #  export RUSTFLAGS="-C target-cpu=native -g"
  #  export FFI_BUILD_FROM_SOURCE=1
  #'';
}
