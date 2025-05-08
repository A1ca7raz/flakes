{ pkgs, lib, config, const, secrets, ... }:
{
  utils.secrets."root/hashed_password".path = secrets.users.root;
  sops.secrets."root/hashed_password".neededForUsers = true;

  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = const.sshkeys;
  } // (with lib.utils; (
    if isDebug
    then { password = "asd"; }
    else { hashedPasswordFile = config.sops.secrets."root/hashed_password".path; }
  ));

  programs.fish.enable = lib.mkDefault true;
}
