# MPLAB X IDE + the XC16 compiler, built from Microchip's own installers.
#
# Self-contained: drop this file next to configuration.nix and add it to imports.
# Two prerequisites, because the installers are proprietary and undistributable:
#
#   1. nixpkgs.config.allowUnfree = true;
#   2. both installer files added to the store once, by hand:
#        nix-store --add-fixed sha256 MPLABX-v6.35-linux-installer.tar
#        nix-store --add-fixed sha256 xc16-v2.10-full-install-linux64-installer.run
#      (a rebuild tells you this, with the exact command, if you forget)
#
# Nothing here is patchelf'd: both the IDE and the toolchain run inside an FHS env,
# which is also the only way the vendor installers run at build time at all.
{ pkgs, ... }:

let
  version = "6.35";

  # Device-family packs to install ("1"/"0"). All four is ~11 GB in the store.
  families = {
    "8bitmcu" = "0";   # PIC10/12/16/18            2.8 GB
    "16bitmcu" = "1";  # dsPIC DSCs, PIC24         2.9 GB
    "32bitmcu" = "0";  # PIC32, SAM                5.0 GB
    othermcu = "0";    # SERIALEE, HCSxxxx         4.8 MB
  };

  targetPkgs = p: with p; [
    zlib libusb1 systemdLibs stdenv.cc.cc.lib
    fontconfig freetype
    gtk2 gtk3 glib pango cairo gdk-pixbuf atk
    alsa-lib libGL libGLU nss nspr
    libx11 libxext libxrender libxtst libxi
    libxrandr libxcursor libxinerama libxcb libxxf86vm
    ncurses which gnumake xdg-utils
  ];

  # The vendor installers exec helper binaries of their own (MPLABCOMM's bundled
  # JRE, XC16's xclm), so they need a real /lib64 loader while they run.
  installerEnv = pkgs.buildFHSEnv { name = "vendor-installer-env"; inherit targetPkgs; };

  # They also refuse to run as non-root and write outside --installdir/--prefix.
  installerPrelude = ''
    set -e
    export HOME=$TMPDIR/home
    export LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
  '';

  unwrapped = pkgs.stdenv.mkDerivation {
    pname = "mplabx-unwrapped";
    inherit version;

    src = pkgs.requireFile {
      name = "MPLABX-v${version}-linux-installer.tar";
      sha256 = "THRzY9z7MVcmQ5+WjQ4lsLFyFLubpdL9Sn87qyjFZwU=";
      url = "https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide";
    };

    dontUnpack = true;
    dontFixup = true; # 8 GB of vendor blobs; the FHS wrapper handles the loader

    installPhase = ''
      runHook preInstall

      tar xf $src

      # makeself 2.1.5 header: payload starts after the line count it computes itself.
      # Unpack it by hand -- Microchip bolted a root check and an ldconfig check for
      # host libraries in front of --noexec.
      skip=$(sed -n 's/^offset=`head -n \([0-9]\+\).*/\1/p' MPLABX-*.sh | head -n1)
      tail -c +$(( $(head -n "$skip" MPLABX-*.sh | wc -c) + 1 )) MPLABX-*.sh | gzip -dc | tar x

      mkdir -p $TMPDIR/home $TMPDIR/fake/usr/share $TMPDIR/fake/etc/udev $out/opt $out/etc

      # /opt and /etc/.mplab_ide are hardcoded and kept; /usr and /etc/udev are not.
      cat > run.sh <<EOF
      ${installerPrelude}
      export NIX_REDIRECTS="/usr=$TMPDIR/fake/usr:/etc/udev=$TMPDIR/fake/etc/udev:/etc/.mplab_ide=$out/etc/.mplab_ide:/opt=$out/opt"
      ${pkgs.fakeroot}/bin/fakeroot $PWD/MPLABX-v${version}-linux-installer.run \
        --mode unattended --unattendedmodeui none --debuglevel 2 \
        --installdir $out/mplabx \
        --ide 1 --ipe 1 \
        ${builtins.concatStringsSep " " (pkgs.lib.mapAttrsToList (k: v: "--${k} ${v}") families)} \
        --collectInfo 0 --collectMyMicrochipInfo 0
      EOF
      # MPLABCOMM's post-install step exits 1 over a symlink it cannot resolve under
      # the redirected /opt; the assertions below are what actually gates the build.
      ${installerEnv}/bin/vendor-installer-env $PWD/run.sh || echo "installer exit $?"

      test -x $out/mplabx/mplab_platform/bin/mplab_ide
      test -d $out/opt/microchip/mplabcomm
      rm -f $out/mplabx/MPLABCOMM-*-linux-installer.run

      # The installer leaves these placeholders behind, so the CLI tools and the
      # NetBeans launcher have no JDK to run.
      jdkhome=$(echo $out/mplabx/sys/java/*)
      substituteInPlace $out/mplabx/mplab_platform/bin/common-vars.sh \
        --replace-fail '##jdkhome##' "$jdkhome/" \
        --replace-fail '##version##' "v${version}"
      for f in $out/mplabx/mplab_platform/etc/mplab_ide.conf \
               $out/mplabx/mplab_platform/etc/mplab_ipe.conf \
               $out/mplabx/mplab_platform/mplab_ipe/jdkloc; do
        echo "jdkhome=\"$jdkhome\"" >> $f
      done

      install -Dm644 $TMPDIR/fake/usr/share/icons/mplab_ide-v${version}.png \
        $out/share/pixmaps/mplab_ide.png

      runHook postInstall
    '';
  };

  xc16 = pkgs.stdenv.mkDerivation rec {
    pname = "xc16";
    version = "2.10";

    src = pkgs.requireFile {
      name = "xc16-v${version}-full-install-linux64-installer.run";
      sha256 = "1k1ec5Hshi1N0Wk2G2aAtyX4lgQ1EhcJtF6xpK/hXcg=";
      url = "https://www.microchip.com/mplab/compilers";
    };

    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      install -m755 $src installer.run
      mkdir -p $TMPDIR/home $TMPDIR/fake/usr $TMPDIR/fake/opt

      # --netservername is demanded even in FreeMode; nothing contacts it.
      cat > run.sh <<EOF
      ${installerPrelude}
      export NIX_REDIRECTS="/usr=$TMPDIR/fake/usr:/opt=$TMPDIR/fake/opt"
      # fakeroot: it wants to chmod 4775 bin/xclm, which the store would reject anyway.
      ${pkgs.fakeroot}/bin/fakeroot $PWD/installer.run \
        --mode unattended --unattendedmodeui none --debuglevel 2 \
        --prefix $out --LicenseType FreeMode --netservername localhost --ModifyAll 0
      EOF
      ${installerEnv}/bin/vendor-installer-env $PWD/run.sh

      test -x $out/bin/xc16-gcc

      runHook postInstall
    '';
  };

  fhs = pkgs.buildFHSEnv {
    name = "mplabx-env";
    # /opt/microchip/mplabcomm is hardcoded in the comm layer used to talk to programmers.
    extraBuildCommands = ''
      mkdir -p opt etc
      ln -s ${unwrapped}/opt/microchip opt/microchip
      ln -s ${unwrapped}/etc/.mplab_ide etc/.mplab_ide
    '';
    profile = ''
      # Swing paints nothing under non-reparenting WMs (Hyprland/sway XWayland, i3, ...).
      export _JAVA_AWT_WM_NONREPARENTING=1
      export PATH=${unwrapped}/mplabx/mplab_platform/bin:${xc16}/bin:$PATH
    '';
    inherit targetPkgs;
  };

  launcher = name: args: pkgs.writeShellScriptBin name ''
    exec ${fhs}/bin/mplabx-env -c 'exec "$@"' mplabx-env ${name} ${args} "$@"
  '';

  # Java 8 Swing has no HiDPI scaling at all, so --fontsize is the only lever.
  fontsize = ''--fontsize "''${MPLAB_FONTSIZE:-16}"'';

  # One wrapper per xc16-* tool, so the toolchain works from a plain shell too.
  xc16Bins = pkgs.runCommand "xc16-bin" { } ''
    mkdir -p $out/bin
    for f in ${xc16}/bin/xc16-*; do
      n=$(basename "$f")
      echo "#!${pkgs.runtimeShell}" > $out/bin/$n
      echo "exec ${fhs}/bin/mplabx-env -c 'exec \"\$@\"' mplabx-env $n \"\$@\"" >> $out/bin/$n
      chmod +x $out/bin/$n
    done
  '';

  desktopItem = pkgs.makeDesktopItem {
    name = "mplab_ide";
    desktopName = "MPLAB X IDE";
    comment = "IDE for Microchip PIC and dsPIC development";
    exec = "mplab_ide";
    icon = "mplab_ide";
    categories = [ "Development" "IDE" ];
    startupWMClass = "MPLAB X IDE v${version}";
  };

  # 60-, not services.udev.extraRules: that writes 99-local.rules, which runs after
  # 73-seat-late.rules has already acted on the uaccess tags, so no ACL is applied.
  # Vendor-wide because the tools re-enumerate under a different product id while
  # MPLAB updates their firmware (PICkit 4: 9012 <-> 9018/8107).
  udevRules = pkgs.writeTextFile {
    name = "mplabx-udev-rules";
    destination = "/lib/udev/rules.d/60-mplabx.rules";
    text = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="04d8", MODE="0660", TAG+="uaccess"
    '';
  };

  mplabx = pkgs.symlinkJoin {
    name = "mplabx-${version}";
    paths = [
      fhs
      (launcher "mplab_ide" fontsize)
      (launcher "mplab_ipe" fontsize)
      (launcher "mdb.sh" "")
      xc16Bins
      desktopItem
      (pkgs.runCommand "mplabx-icon" { } ''
        install -Dm644 ${unwrapped}/share/pixmaps/mplab_ide.png \
          $out/share/pixmaps/mplab_ide.png
      '')
    ];
    passthru = { inherit unwrapped xc16; };
    meta = {
      description = "MPLAB X IDE ${version}";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "mplab_ide";
    };
  };
in
{
  environment.systemPackages = [ mplabx ];
  services.udev.packages = [ udevRules ];
}
