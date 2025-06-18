{
  locale,
  timeZone,
  pkgs,
  ...
}: {
  time.timeZone = timeZone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.en_US
    hunspellDicts.ru_RU
    hyphen
    nuspell
  ];

  location.provider = "geoclue2";
  services.geoclue2.enable = true;
  time.hardwareClockInLocalTime = true;
}
