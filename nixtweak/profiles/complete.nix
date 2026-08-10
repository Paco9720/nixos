{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    nano
    fish

    gcc
    gnumake
    pkg-config
    cmake
    ninja
    gdb

    python3
    nodejs

    ripgrep
    fd
    tree-sitter

    qt6.qtbase
  ];
}
