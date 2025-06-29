
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openai # python client library for the OpenAI API
  ];
}
