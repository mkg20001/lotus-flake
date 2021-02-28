{ buildGoModule
, lotusSrc
, filcrypto
, pkg-config
}:

buildGoModule {
  pname = "filecoin-ffi";
  version = "0.0.0";

  doCheck = false;

  src = "${lotusSrc}/extern/filecoin-ffi";

  vendorSha256 = "sha256-09I6RF+jWLNyfiNEci0C8+kq647kG7uiwk3iXx3A8Jc=";

  preBuild = ''
    ls
    find ${filcrypto} -type f -exec ln -s {} . \;
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    filcrypto
  ] ++ filcrypto.buildInputs;
}
