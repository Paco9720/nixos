```nix
{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.desktopManager.pantheon.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.pantheon.apps.enable = false;

  environment.systemPackages = with pkgs; [
    pantheon.elementary-files
    pantheon.elementary-terminal
  ];
}
```

