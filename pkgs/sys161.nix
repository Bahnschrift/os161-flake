{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "sys161";
  version = "2.0.8";

  src = fetchurl {
    url = "http://os161.org/download/sys161-2.0.8.tar.gz";
    hash = "sha256-WmQgkMUdovDRkrxFINaariYiI6vcv50dcE8hrm/ZGyY=";
  };

  dontUpdateAutotoolsGnuConfigScripts = true;
  env = {
    NIX_CFLAGS_COMPILE = "-fcommon -std=gnu99";
    CXXFLAGS = "-std=gnu++14";
  };

  configureFlags = [ "mipseb" ];

  meta = {
    description = "System/161 MIPS machine simulator for OS/161";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "sys161";
  };
}
