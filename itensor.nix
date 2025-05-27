{ stdenv, cmake, lib, gcc, openblas, debug ? false, llvmPackages }:

let
  name = "itensor";
  build-type = if debug then "Debug" else "Release";
in stdenv.mkDerivation {
  pname = "${name}";
  version = "3.2.0";

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = (lib.optionals stdenv.cc.isGNU [ gcc openblas ])
    ++ (lib.optionals stdenv.cc.isClang [
      # TODO: This may mismatch the LLVM version sin the stdenv, see #79818.
      # llvmPackages.openblas
      llvmPackages.openmp
    ]);

  src = ./.;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${build-type}"
    "-DCMAKE_EXPORT_COMPILE_COMMANDS=YES"
    "-DNIX_LIBRARY_NAME=${name}"
    "-DCMAKE_BUILD_TYPE=Release"
    #-DCMAKE_INSTALL_LIBDIR=out/lib
    # other flags...
  ];

  # configurePhase = ''
  #   cmake  \
  #          \
  #          \
  #          \
  #         -B build -S .
  # '';
  #-DCMAKE_INSTALL_LIBDIR=$lib/lib \

  # buildPhase = ''
  #   cmake --build build
  # '';
  # installPhase = ''
  #   mkdir -p $out
  #   mkdir -p $dev/include
  #   cmake --install build
  # '';
  #mkdir -p $lib/lib

  meta = {
    description =
      "An efficient and flexible C++ library for performing tensor network calculations";
    license = lib.licenses.asl20;
  };
}
