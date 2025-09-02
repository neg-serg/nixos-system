{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat # Use GPT-4(V), Gemini, LocalAI, Ollama, etc. in terminal
    codex # lightweight coding agent that runs in your terminal
    aider-chat # Aider CLI assistant
    openai # Python client library for OpenAI API
    voxinput # voice→text via LocalAI/OpenAI + dotool/uinput
  ];
}
