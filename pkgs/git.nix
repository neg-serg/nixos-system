{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git # my favorite dvcs
    git-extras # git extra stuff
    git-filter-repo # quickly rewrite git history
    git-lfs # git extension for large files
  ];
}
