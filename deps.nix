{ pkgs, ... }:
{
# dependences
environment.systemPackages = with 
pkgs; [
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
  python3
  qt6.qtbase
  python3
];
}
