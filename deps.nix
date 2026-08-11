{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    pkg-config
    tree-sitter
    nodejs
    git
    cmake
    ninja
    gdb
    ripgrep
    fd

    qt6.qtbase

    python3
    mesa
    fontconfig

    zlib
    libx11
    harfbuzz
    freetype
    libxcrypt
    gmp
    krb5

    extract-xiso
  ];
}
