{
  buildNpmPackage,
  internal,
  ...
}:
buildNpmPackage {
  inherit (internal.grayjay-desktop) version;
  pname = "grayjay-desktop-web";
  src = "${internal.grayjay-desktop.src}/Grayjay.Desktop.Web";

  npmDepsHash = "sha256-pTEbMSAJwTY6ZRriPWfBFnRHSYufSsD0d+hWGz35xFM=";

  postBuild = "cp -r ./dist $out/";
  # fixupPhase = "rm -rf $out/lib";
}
