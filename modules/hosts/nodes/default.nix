{ variables, ... }:
{
  networking.hosts = variables.nodes.hosts;
}
