{ ... }:
{
  utils.kconfig.kiorc.content = {
    Confirmations = {
      ConfirmDelete = false;
      ConfirmEmptyTrash = false;
      ConfirmTrash = false;
    };
    "Executable scripts".behaviourOnLaunch = "open";
  };
}
