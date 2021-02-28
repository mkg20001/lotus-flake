{ rustPlatform
, lotusSrc
, opencl-headers
, opencl-icd
, openssl
, hwloc
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "filecrypto";
  version = "0.0.0";

  doCheck = false; # requires elevated permissions

  src = "${lotusSrc}/extern/filecoin-ffi/rust";

  cargoSha256 = "sha256-QWbHgp065EUeBe8dcQlK4b99zvN4TmORv7Nc7BC0Uqg=";

  nativeBuildInputs = [
    pkg-config openssl.dev
  ];

  preBuild = ''
    LOGFILE=$(mktemp)
    exec \
      1> >(tee >(awk '{ system(""); print $0; system(""); }' >> "$LOGFILE")) \
      2> >(tee >(awk '{ system(""); print $0; system(""); }' >> "$LOGFILE") >&2)

      export OPENSSL_LIB_DIR=${openssl.out}/lib
      export OPENSSL_INCLUDE_DIR=${openssl.dev}/include
      export OPENSSL_NO_VENDOR=true
      export OUT_DIR=$out
  '';

  RUSTFLAGS = "--print native-static-libs";

  postInstall = ''
    # install -D include/filcrypto.h $out/include
    local PRIVATE_LIBS=$(cat ''${LOGFILE} \
        | grep native-static-libs\: \
        | head -n 1 \
        | cut -d ':' -f 3)
    mkdir -p $out/lib/pkgconfig
    echo 'prefix='"''${out}"'
    exec_prefix=''${prefix}
    libdir=''${exec_prefix}/lib
    includedir=''${prefix}/include' > $out/lib/pkgconfig/filcrypto.pc
      cat filcrypto.pc.template | sed "s|@VERSION@|0.0.0|" | sed "s|@PRIVATE_LIBS@|$PRIVATE_LIBS|" >> $out/lib/pkgconfig/filcrypto.pc
      mkdir -p $out/include
      find -L . -type f -name filcrypto.h -exec cp -- "{}" $out/include/ \;
  '';

  buildInputs = [
    opencl-headers opencl-icd openssl.out hwloc
  ];
}
