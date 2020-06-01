# vi: ft=sh
#
# /etc/btrborg/profile
#

# These are the same environment variables borg uses, so set them accordingly.
BORG_REPO=
BORG_PASSPHRASE=

# Add other btrfs filesystem mountpoints to include in your backups here.
# btrborg will create a hidden snapshot directory in the mount point directory
# and use it for backup creation the same way it does with the root filesystem.
other_btrfs_roots=(

)

# Add other non-btrfs filesystems to include in your backups here. They will be
# passed as separate paths to borg-create(1) and thus added to the backup,
# though since btrborg currently only supports btrfs snapshots, some files may
# end up inconsistent.
#
# On most systems, /boot is a separate partition (often ext2/ext3/ext4/FAT)
# with files that change infrequently, which makes it a good candidate for this
# setting.
other_source_paths=(
  /boot
)

