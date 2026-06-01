{
  stdenv,
  fetchurl,
  lib,
  gmp,
  mpfr,
  libmpc,
  os161-binutils,
  makeOs161Symlinks,
}:

stdenv.mkDerivation {
  pname = "os161-gcc";
  version = "4.8.3+os161-2.1";

  src = fetchurl {
    url = "http://os161.org/download/gcc-4.8.3+os161-2.1.tar.gz";
    hash = "sha256-BwZZ0Uq2+QXp34mJG3j54FLBFODE0BHGMLLwd4jQNZ4=";
  };

  dontConfigure = true;

  nativeBuildInputs = [ os161-binutils ];
  buildInputs = [
    gmp
    mpfr
    libmpc
  ];

  dontUpdateAutotoolsGnuConfigScripts = true;
  hardeningDisable = [ "all" ];
  env = {
    NIX_CFLAGS_COMPILE = "-fcommon -std=gnu99";
    CXXFLAGS = "-std=gnu++14";
  };

  postUnpack = ''
    find . -name '*.info' | xargs touch
    touch $sourceRoot/intl/plural.c
  '';

  buildPhase = ''
    mkdir buildgcc && cd buildgcc
    ../configure \
      --enable-languages=c,lto \
      --nfp \
      --disable-shared \
      --disable-threads \
      --disable-libmudflap \
      --disable-libssp \
      --disable-libstdcxx \
      --disable-nls \
      --target=mips-harvard-os161 \
      --prefix=$out \
      --with-gmp=${gmp} \
      --with-mpfr=${mpfr} \
      --with-mpc=${libmpc} \
      --with-as=${os161-binutils}/bin/mips-harvard-os161-as \
      --with-ld=${os161-binutils}/bin/mips-harvard-os161-ld
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    make install
    ${makeOs161Symlinks}
  '';

  meta = {
    description = "GCC 4.8 cross-compiler for OS/161 (mips-harvard-os161)";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
