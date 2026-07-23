{ config, ... }:
{
# mount disks
  fileSystems."/mnt/sda1" = {
  device = "/dev/disk/by-uuid/441918ac-3253-4851-993b-8b0d037f75b2";
  fsType = "ext4";
  options = [ "defaults" "nofail" ];
};
}
