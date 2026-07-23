{ config, ... }:
{
# mount disks
  fileSystems."/mnt/sda1" = {
  device = "/dev/disk/by-uuid/e44804fe-5f3c-441e-bcde-882bf10b80e4";
  fsType = "ext4";
  options = [ "defaults" "nofail" ];
};
}
