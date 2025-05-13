{ ... }:
{
  security.pki.certificates = [
    (builtins.readFile ./r1.crt)
  ];
}
