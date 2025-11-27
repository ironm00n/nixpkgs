{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  swift,
  swiftpmHook,
  stdenv,
  swift_release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-format";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-format";
    tag = "swift-${finalAttrs.version}-RELEASE";
    hash = "sha256-DhTtGU2B9BIyN6PyLBlg7kIs3cVyRl6Pa9G0txzta0g=";
  };

  postPatch =
    # Fix the deployment target or compiling code using XCTest fails.
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Package.swift \
        --replace-fail '.macOS("13.0")' ".macOS(\"$MACOSX_DEPLOYMENT_TARGET\")"
    '';

  strictDeps = true;

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    swift
    swiftpmHook
  ];
})
