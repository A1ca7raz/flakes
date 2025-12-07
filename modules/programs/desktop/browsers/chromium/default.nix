{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "chromium")
    ];

  homeModule = { pkgs, ... }: {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];

#       commandLineArgs = [
#         "--ozone-platform-hint=auto"  # Touchpad Gestures for Navigation
#
#         # Accelerated video playback
#         "--ignore-gpu-blocklist"
#         "--enable-zero-copy"
#
#         ("--enable-features=" +
#           builtins.concatStringsSep "," [
#             "TouchpadOverscrollHistoryNavigation" # Touchpad Gestures for Navigation
#
#             # Accelerated video playback
#             "VaapiVideoDecoder"
#             "AcceleratedVideoEncoder"
#             "VaapiOnNvidiaGPUs"
#             "VaapiIgnoreDriverChecks"
#             "PlatformHEVCDecoderSupport"
#             "UseMultiPlaneFormatForHardwareVideo"
#
#             "Vulkan,DefaultANGLEVulkan,VulkanFromANGLE" # Vulkan
#           ]
#         )
#
#         # Disable popup shortcut setting window
#         "--disable-features=GlobalShortcutsPortal"
#       ];

      # NOTE: extensions does not work for ungoogled-chromium
    };

    xdg.mimeApps.defaultApplications =
      let
        chromium = "chromium-browser.desktop";
      in {
        "x-scheme-handler/http" = chromium;
        "x-scheme-handler/https" = chromium;
        "text/html" = chromium;
      };
  };
}
