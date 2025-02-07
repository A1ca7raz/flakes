lib:
let
  inherit (lib)
    forEach
    elemAt
  ;

  inherit (builtins)
    genList
    length
  ;
in rec {
  mkPanel = {
    id,
    appletBaseId ? 100,
    plugin ? "org.kde.panel",
    applets ? [],
    formfactor ? 2,
    lastScreen,
    location,
    config ? {},
  }: {
    inherit id formfactor lastScreen location plugin config;

    applets =
      let
        ids = genList (x: x) (length applets);
        mkId = index: appletBaseId + index + 1;
      in
        forEach ids (id:
          (elemAt applets id) // {
            id = mkId id;
          }
        )
      ;
  };

  mkTopbar = {
    id,
    appletBaseId,
    applets ? [],
    lastScreen,
    config ? {}
  }: mkPanel {
    inherit id appletBaseId applets lastScreen config;
    formfactor = 2;
    location = 3;
  };

  mkDock = {
    id,
    appletBaseId,
    applets ? [],
    lastScreen,
    config ? {}
  }: mkPanel {
    inherit id appletBaseId applets lastScreen config;
    formfactor = 2;
    location = 4;
  };

  mkTray = extraConfig: id: lastScreen: {
    inherit id lastScreen extraConfig;
    immutability = "1";
    formfactor = "2";
    location = "3";
    plugin = "org.kde.plasma.private.systemtray";
  };
}
