{ buildGoModule
, lotusSrc
, filcrypto
, pkg-config
, lib
}:

buildGoModule {
  pname = "filecoin-ffi";
  version = "0.0.0";

  doCheck = false;

  src = "${lotusSrc}/extern/filecoin-ffi";

  vendorSha256 = "sha256-enaKv8iCKnM5c3JBjL2Fao69dZIcsNxyQTYRluvq5XI=";

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
