{ stdenv, makeWrapper, pkgs,
  bash, coreutils, utillinux, borgbackup, btrfsProgs }:

let
  btrborgBinPath = [bash coreutils utillinux borgbackup btrfsProgs];
in

stdenv.mkDerivation rec {
  name = "btrborg-${version}";
  version = "git";
  src = ./.;
  buildInputs = [ makeWrapper ];

  doCheck = true;
  checkPhase = ''
    ${pkgs.shellcheck}/bin/shellcheck ./btrborg
  '';

  installPhase = ''
    install -Dt $out/lib btrborg
    makeWrapper $out/lib/btrborg $out/bin/btrborg \
      --set PATH ${stdenv.lib.makeBinPath btrborgBinPath}
  '';
}
