{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.en_US
    hunspellDicts.ru_RU
    hyphen
    nuspell
  ];
}

