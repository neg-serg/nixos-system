{pkgs, ...}: {
  programs.zsh = {enable = true;};
  environment.systemPackages = with pkgs; [
    bash-completion # generic bash completions
    dash # faster sh
    nix-bash-completions # nix-related bash-completions
    nix-zsh-completions # nix-related zsh-completion
    nushell # modern shell written in Rust
    oils-for-unix # better bash
  ];
}
