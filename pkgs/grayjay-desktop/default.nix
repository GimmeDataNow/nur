{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitLab,
  internal,
  autoPatchelfHook,
  libz,
  icu,
  openssl,
  xorg,
  gtk3,
  glib,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  expat,
  libxkbcommon,
  pango,
  cairo,
  udev,
  alsa-lib,
  mesa,
  libGL,
  libsecret,
}:
buildDotnetModule {
  pname = "grayjay-desktop";
  version = "0-unstable-2025-24-01";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "VideoStreaming";
    repo = "Grayjay.Desktop";
    rev = "1c116e4fc17177ca2c8e2054cb83a8138bcc3de7";
    hash = "sha256-fGjfJlNEZx9wPtMKGN8jJRBI36ko9LNlY0osghPO1qo=";
    fetchSubmodules = true;
    fetchLFS = true;
  };

  patches = [./launch.patch ./wwwroot.patch];

  executables = "Grayjay";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  nugetDeps = ./deps.json;
  projectFile = "Grayjay.Desktop.CEF/Grayjay.Desktop.CEF.csproj";

  nativeBuildInputs = [autoPatchelfHook];

  postInstall = ''
    mkdir -p $out/lib/grayjay-desktop/wwwroot
    ln -s ${internal.grayjay-web} $out/lib/grayjay-desktop/wwwroot/web
    rm $out/lib/grayjay-desktop/Portable
  '';

  dontAutoPatchelf = true;
  preFixup = ''
    addAutoPatchelfSearchPath $out/lib/grayjay-desktop/cef
  '';
  postFixup = ''
    autoPatchelf $out/lib/grayjay-desktop/cef/dotcefnative
  '';

  buildInputs = [
    xorg.libX11
    gtk3
    glib
  ];

  runtimeDeps = [
    libz
    icu
    openssl # For updater

    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    gtk3
    glib
    nss
    nspr
    dbus
    atk
    cups
    libdrm
    expat
    libxkbcommon
    pango
    cairo
    udev
    alsa-lib
    mesa
    libGL
    libsecret
  ];

  meta = {
    mainProgram = "Grayjay";
  };
}
