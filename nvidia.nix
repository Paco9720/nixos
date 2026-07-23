{ config, ... }:
{
# driver nvidia
services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    branch = "legacy_580";
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;

    prime = {
      offload.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
  };
};
}
