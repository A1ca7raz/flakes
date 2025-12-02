{ home, ... }:
{
  programs.git = {
    enable = true;
    userName = "A1ca7raz";
    userEmail = "7345998+A1ca7raz@users.noreply.github.com";

    settings.alias = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      st = "status";
    };
  };
}
