{ pkgs, lib, config, const, secrets, ... }:
let
  inherit (lib)
    mkIf
    utils
    mkDefault
  ;
in {
  utils.secrets."root/hashed_password".path = secrets.users.root;
  sops.secrets."root/hashed_password".neededForUsers = true;

  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = const.sshkeys;
  } // (
    if utils.isDebug
    then { password = "asd"; }
    else { hashedPasswordFile = config.sops.secrets."root/hashed_password".path; }
  );

  environment.persistence."/nix/persist".directories = mkIf utils.isServer [
    "/root/.cache"
  ];

  programs.fish.enable = mkDefault true;
}
