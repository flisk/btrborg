{ config, lib, pkgs, ... }:

with lib;

let
  pkgName = "btrborg";
  pkg = pkgs.${pkgName};
  cfg = config.programs.${pkgName};

  profileShim = pkgs.writeText "btrborg-profile-shim" ''
    . ${cfg.profile}

    other_btrfs_roots=(
    ${concatStringsSep "\n" cfg.otherBtrfsRoots}
    )

    other_source_paths=(
    ${concatStringsSep "\n" cfg.otherSourcePaths}
    )
  '';

  excludeFrom = pkgs.writeText "btrborg-exclude-from" cfg.exclude;

  btrborgShim = pkgs.writeShellScriptBin "btrborg" ''
    export btrborg_profile=${profileShim}
    export btrborg_exclude=${excludeFrom}
    exec ${pkg}/bin/btrborg "$@"
  '';

in {

  options = {

    programs.${pkgName} = {

      enable = mkEnableOption pkgName;

      profile = mkOption {
        type = types.path;
        default = null;
        description = ''
          Location of the shell file containing BORG_REPO and
          BORG_PASSPHRASE.
        '';
      };

      autoDaily = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable daily automatic backups.
        '';
      };

      autoCPUQuota = mkOption {
        type = types.str;
        default = "";
        description = ''
          CPU quota for btrborg.service.
        '';
      };

      otherBtrfsRoots = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          Add other btrfs filesystem mountpoints to include in your
          backups here. btrborg will create a hidden snapshot
          directory in the mount point directory and use it for backup
          creation the same way it does with the root filesystem.
      '';
      };

      otherSourcePaths = mkOption {
        type = types.listOf types.path;
        default = [
          "/boot"
        ];
        description = ''
          Add other non-btrfs filesystems to include in your backups
          here. They will be passed as separate paths to
          borg-create(1) and thus added to the backup, though since
          btrborg currently only supports btrfs snapshots, some files
          may end up inconsistent.
          </para>
          <para>
          On most systems, /boot is a separate partition (often
          ext2/ext3/ext4/FAT) with files that change infrequently,
          which makes it a good candidate for this setting.
      '';
      };

      exclude = mkOption {
        type = types.lines;
        default = ''
          home/*/.cache/*
          root/.cache/*
          tmp/*
          var/cache/*
          var/tmp/*
        '';
        description = ''
          Patterns to exclude from backups.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ btrborgShim ];

    systemd.services.${pkgName} = {
      description = "Create a borg archive with btrborg";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${btrborgShim}/bin/btrborg create";
        CPUQuota = cfg.autoCPUQuota;
      };
    };

    systemd.timers.${pkgName} = {
      enable = cfg.autoDaily;
      description = "Daily btrborg backup timer";
      timerConfig = {
        OnCalendar = "3:00";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };

  };

}
