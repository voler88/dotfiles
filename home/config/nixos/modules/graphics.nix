{
  # Display Manager.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Window Manager.
  programs.niri.enable = true;
}
