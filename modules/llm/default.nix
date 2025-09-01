{...}: {
  imports = [./pkgs.nix];
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    models = "/zero/llm/ollama-models";
  };
  systemd.tmpfiles.rules = [
    "d /zero/llm 0750 ollama ollama -"
    "d /zero/llm/ollama-models 0750 ollama ollama -"
  ];
  users.groups.ollama = {};
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/zero/llm/ollama-models";
    createHome = true;
  };
}
