{
  stdenv,
  fetchurl,
  lib,
  makeOs161Symlinks,
}:

stdenv.mkDerivation {
  pname = "os161-binutils";
  version = "2.24+os161-2.1";

  src = fetchurl {
    url = "http://os161.org/download/binutils-2.24+os161-2.1.tar.gz";
    hash = "sha256-fBIhrVOO4tcs5La62ZbXAbKo4hl3wP18m7YCDANc5mQ=";
  };

  dontUpdateAutotoolsGnuConfigScripts = true;
  env.NIX_CFLAGS_COMPILE = "-fcommon -std=gnu99";

  postUnpack = ''
    find . -name '*.info' | xargs touch
    touch $sourceRoot/intl/plural.c
  '';

  configureFlags = [
    "--nfp"
    "--disable-werror"
    "--target=mips-harvard-os161"
  ];

  postInstall = makeOs161Symlinks;

  meta = {
    description = "GNU binutils cross-compiled for OS/161 (mips-harvard-os161)";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
