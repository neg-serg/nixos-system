{pkgs, ...}: {
  programs.zsh = {enable = true;};
  environment.systemPackages = with pkgs; [
    bash-completion # generic bash completions
    nix-bash-completions # nix-related bash-completions
    nix-zsh-completions # nix-related zsh-completion
  ];
}
