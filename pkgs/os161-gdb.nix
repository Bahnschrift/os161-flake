{
  stdenv,
  fetchurl,
  lib,
  ncurses,
  readline,
  makeOs161Symlinks,
}:

stdenv.mkDerivation {
  pname = "os161-gdb";
  version = "7.8+os161-2.1";

  src = fetchurl {
    url = "http://os161.org/download/gdb-7.8+os161-2.1.tar.gz";
    hash = "sha256-HBbi2Ds7/lLoEz48On0fCDstAQ/hwQenjt5kObGx/mE=";
  };

  buildInputs = [
    ncurses
    readline
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

  configureFlags = [
    "--target=mips-harvard-os161"
    "--disable-werror"
    "--disable-sim"
    "--with-system-readline"
  ];

  postInstall = makeOs161Symlinks;

  meta = {
    description = "GDB cross-debugger for OS/161 (mips-harvard-os161)";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
