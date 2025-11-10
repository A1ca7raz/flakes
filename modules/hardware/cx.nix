{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mstflint
    rdma-core
  ];

  # TODO: enable RDMA
  # systemd.packages = [
  #   pkgs.rdma-core
  # ];

  # systemd.services = {
  #   "rdma-load-modules@rdma".wantedBy = [ "multi-users.target" ];
  #   "rdma-load-modules@infiniband".wantedBy = [ "multi-users.target" ];
  # };
}
