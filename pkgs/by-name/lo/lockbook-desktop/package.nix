{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  glib,
  gobject-introspection,
  gdk-pixbuf,
  libxkbcommon,
  vulkan-loader,
  makeDesktopItem,
  autoPatchelfHook,
  copyDesktopItems,
}:
let
  desc = "Private, polished note-taking platform";
in
rustPlatform.buildRustPackage rec {
  pname = "lockbook-desktop";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    tag = version;
    hash = "sha256-SRmfLxF78jR1a/37pU1TLM6nFpmYLRbHJzQIVQtM8/M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-faqbsxXF2AjDE+FMkD1PihacPAvQlD6nkczN4QdsCeM=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    gobject-introspection
    gdk-pixbuf
    libxkbcommon
  ];

  runtimeDependencies = [
    vulkan-loader
  ];

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook-linux"
  ];

  desktopItems = makeDesktopItem {
    desktopName = "Lockbook";
    name = "lockbook-desktop";
    comment = desc;
    icon = "lockbook";
    exec = "lockbook-desktop";
    categories = [
      "Office"
      "Documentation"
      "Utility"
    ];
  };

  postInstall = ''
    mv $out/bin/lockbook-linux $out/bin/lockbook-desktop
    install -D public_site/favicon.svg $out/share/icons/hicolor/scalable/apps/lockbook.svg
  '';

  meta = {
    description = desc;
    longDescription = ''
      Write notes, sketch ideas, and store files in one secure place.
      Share seamlessly, keep data synced, and access it on any
      platform—even offline. Lockbook encrypts files so even we
      can’t see them, but don’t take our word for it:
      Lockbook is 100% open-source.
    '';
    homepage = "https://lockbook.net";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/lockbook/lockbook/releases/tag/${version}";
    maintainers = [ lib.maintainers.parth ];
  };
}
