{ lib, ... }@args:
let
  util = (import ./fold.nix args) // (import ./nix.nix args);
in with util; {
  importsFiles = dir: foldFileIfExists dir []
    (x: y:
      if isNix x
      then [ /${dir}/${x} ] ++ y
      else y
    );

  importsFilesNotDefault = dir: foldFileIfExists dir []
    (x: y:
      if isNix x && ! isDefault x
      then [ /${dir}/${x} ] ++ y
      else y
    );

  importsDirs = dir: foldDirIfExists dir [] (x: y: [ /${dir}/${x} ] ++ y);
}