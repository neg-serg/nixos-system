{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  libpulseaudio,
  openssl,
  stdenv,
  darwin,
  alsa-lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "camilladsp";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "HEnquist";
    repo = "camilladsp";
    rev = "v${version}";
    hash = "sha256-E/KlwXoKvkuMPEKAZv/6l0F1KikZNFpw/9Iiw+Z8q/I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      bzip2
      libpulseaudio
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  meta = with lib; {
    description = "A flexible cross-platform IIR and FIR engine for crossovers, room correction etc";
    homepage = "https://github.com/HEnquist/camilladsp";
    changelog = "https://github.com/HEnquist/camilladsp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "camilladsp";
  };
}
