{pkgs ? import <nixpkgs> { } }:

let
  jdk = pkgs.jdk21;
in
pkgs.mkShell {
  name = "shogi-and-chess-variations";

  packages = with pkgs; [
    jdk
    gradle
    kotlin
    kotlin-language-server

    libGL
    libx11
    libxext
    libxrender
    libxi
    libxrandr
    libxcursor
    libxfixes
    libxinerama
    mesa

    git
    gnumake
    pkg-config
    stockfish
    yaneuraou
  ];

  JAVA_HOME = "${jdk}";
  GRADLE_OPTS = "-Dorg.gradle.java.home=${jdk}";

  shellHook = ''
    export PATH="$JAVA_HOME/bin:$PATH"
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.libGL
      pkgs.libx11
      pkgs.libxext
      pkgs.libxrender
      pkgs.libxi
      pkgs.libxrandr
      pkgs.libxcursor
      pkgs.libxfixes
      pkgs.libxinerama
      pkgs.mesa
    ]}:$LD_LIBRARY_PATH"

    echo "ShogiAndChessVariations development shell"
    echo "Java:   $(java --version 2>&1 | head -n 1)"
    echo "Kotlin:   $(kotlinc -version 2>&1 | head -n 1)"
    echo "Gradle:   $(gradle --version | grep '^Gradle' | head -n 1)"
    '';
}
