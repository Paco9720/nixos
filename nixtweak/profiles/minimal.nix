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
  ];
}
