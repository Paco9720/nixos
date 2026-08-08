```nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Navegadores
    firefox

    # Multimedia
    vlc

    # Oficina
    libreoffice

    # Desarrollo
    git
    neovim

    # Editores
    vscode

    # Grabación / streaming
    obs-studio

    # Utilidades
    curl
    wget
    unzip
    p7zip
    file
    xarchiver

    # Sistema
    htop
    fastfetch
  ];

  programs.steam.enable = true;
}
```

