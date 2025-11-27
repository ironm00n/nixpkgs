{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  stdenv,
  swift,
  swiftpmHook,
  swift_release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-docc";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-docc";
    tag = "swift-${finalAttrs.version}-RELEASE";
    hash = "sha256-zu70RyYvnfhW3DdovSeLFXTNmdHrhdnSYCN8RisSkt8=";
  };

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-bq4YF3gbjj9aqogC0Is1tYKFCzSnf9jX4aghXvmxK18=";
  };

  nativeBuildInputs = [
    swift
    swiftpmHook
  ];

  meta = {
    description = "Documentation compiler for Swift";
    mainProgram = "docc";
    homepage = "https://github.com/apple/swift-docc";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
