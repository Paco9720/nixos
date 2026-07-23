{ pkgs, ... }:

{
environment.systemPackages = with 
  pkgs; [
	neovim
	htop
	fastfetch
	ptyxis
	papirus-icon-theme
	gnome-tweaks
	google-chrome
	vlc
	git
	wget
	curl
	wl-clipboard
	nautilus
	file-roller
	zip
  ];

environment.gnome.excludePackages = with 
  pkgs; [
  gnome-contacts
  gnome-font-viewer
  gnome-connections
  gnome-characters
  gnome-music
  gnome-maps
  gnome-text-editor
  gnome-tour
  gnome-system-monitor
  gnome-logs
  gnome-weather
  gnome-console
  pkgs.epiphany
  gnome-keyring
  showtime
  decibels
  simple-scan
  xterm
  snapshot
  seahorse
  ];

#basic config

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld = {
  enable = true;

  libraries = with pkgs; [
    # Qt6
    qt6.qtbase
    qt6.qtwayland

    # OpenGL
    libglvnd
    mesa

    # X11 / XCB
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXrandr
    xorg.libXcursor
    xorg.libxcb

    # Multimedia / sistema
    glib
    zlib
    fontconfig
    freetype
    dbus
    libpulseaudio

    # Vulkan (por si algún programa lo requiere)
    vulkan-loader
  ];
};

# AppImgae Fuse

boot.kernelModules = [ "fuse" ];

programs.appimage = {
  enable = true;
  binfmt = true;
};
}


