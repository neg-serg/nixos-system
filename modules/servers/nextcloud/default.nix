{pkgs, ...}: {
  environment.etc."nextcloud/admin-pass".text = "eizoo4queegobaeFe7fae0eica9xeecea9Uu1vu4ar0gohyo";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "localhost";
    database.createLocally = true;
    configureRedis = true;
    datadir = "/nextcloud";
    config = {
      adminuser = "init";
      adminpassFile = "/etc/nextcloud/admin-pass";
      dbtype = "mysql";
    };
  };
}
