{ pkgs, lib, config, const, secrets, ... }:
{
  utils.secrets."nomad/hashed_password".path = secrets.users.nomad;
  sops.secrets."nomad/hashed_password".neededForUsers = true;

  users.users.nomad = {
    isNormalUser = true;
    extraGroups = [ "wheel" "realtime" "tss" ];
    shell = pkgs.fish;

    # Authentication
    hashedPasswordFile = config.sops.secrets."nomad/hashed_password".path;
    openssh.authorizedKeys.keys = const.sshkeys;
  };

  environment.persistence."/nix/persist".users.nomad.directories = [
    # Home
    ".cache"
    ".local/state"
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Videos"
    "Workspace"
  ];

  programs.fish.enable = lib.mkDefault true;
}
