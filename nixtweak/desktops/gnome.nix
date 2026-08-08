```nix
{ config, pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.gnome.core-apps.enable = false;

  environment.systemPackages = with pkgs; [
    nautilus
    gnome-terminal
  ];
}
```

