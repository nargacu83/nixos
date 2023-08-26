{ config, lib, pkgs, ... }:

{
  systemd = {
    # Enable HIP for most softwares
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
    ];
    user = {
      # Make xdg-desktop-portal aware of each portals (should be upstreamed)
      services.xdg-desktop-portal.environment = {
        XDG_DESKTOP_PORTAL_DIR = config.environment.variables.XDG_DESKTOP_PORTAL_DIR;
      };
      extraConfig = ''
        DefaultEnvironment="PATH=/run/current-system/sw/bin"
        DefaultLimitNOFILE=1048576
      '';
      # Polkit GTK
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
      };
    };
  };
}
