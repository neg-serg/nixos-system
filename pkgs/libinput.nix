{
  config.services.libinput = {
    enable = true;

    # disable mouse acceleration
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
      middleEmulation = false;
    };

    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      horizontalScrolling = false;
      disableWhileTyping = true;
    };
  };
}
