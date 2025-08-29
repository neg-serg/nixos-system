
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat # Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal
    codex # lightweight coding agent that runs in your terminal
    openai # python client library for the OpenAI API
    voxinput # Voice to text for any Linux app via dotool/uinput and the LocalAI/OpenAI transcription API
  ];
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
