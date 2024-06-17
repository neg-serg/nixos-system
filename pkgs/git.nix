{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git-crypt # git-based incryption
    git-extras # git extra stuff
    git-filter-repo # quickly rewrite git history
    git-lfs # git extension for large files
    git # my favorite dvcs
  ];
}
