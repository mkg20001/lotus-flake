{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lotus;
in
{
  options = {
    services.lotus = {
      enable = mkEnableOption "Lotus Daemon";
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      # for managment
      lotus
    ];
  };
}
