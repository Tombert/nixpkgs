{
  lib,
  stdenv,
  fetchurl,
  pciutils,
}:

stdenv.mkDerivation {
  pname = "i810switch";
  version = "0.6.5";

  installPhase = "
    sed -i -e 's+/usr++' Makefile
    sed -i -e 's+^\\(.*putenv(\"PATH=\\).*$+\\1${pciutils}/sbin\");+' i810switch.c
    make clean
    make install DESTDIR=\${out}
  ";

  src = fetchurl {
    url = "http://www16.plala.or.jp/mano-a-mano/i810switch/i810switch-0.6.5.tar.gz";
    sha256 = "d714840e3b14e1fa9c432c4be0044b7c008d904dece0d611554655b979cad4c3";
  };

  meta = with lib; {
    description = "Utility for switching between the LCD and external VGA display on Intel graphics cards";
    homepage = "http://www16.plala.or.jp/mano-a-mano/i810switch.html";
    maintainers = [ ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
