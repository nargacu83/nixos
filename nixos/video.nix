{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpeg_6-full
    ffmpegthumbnailer
  ];

  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst-plugins-base
    # Specialized plugins separated by quality
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst-vaapi
  ]);
}
