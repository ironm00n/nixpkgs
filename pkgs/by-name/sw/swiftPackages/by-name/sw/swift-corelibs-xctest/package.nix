{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  swift-no-testing,
  swift_release,
}:

# FIXME: fix outputs to match other builds
# Build with CMake instead of SwiftPM to avoid SwiftPM and XCTest mutually depending on each other.
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-corelibs-xctest";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-corelibs-xctest";
    tag = "swift-${finalAttrs.version}-RELEASE";
    hash = "sha256-BbzY1kZUaHu7O29c8J7xDuelik6lhqmfSSskvvPZ7R4=";
  };

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "USE_FOUNDATION_FRAMEWORK" true) ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift-no-testing
  ];

  __structuredAttrs = true;

  meta = {
    description = "Framework for writing unit tests in Swift";
    homepage = "https://github.com/swiftlang/swift-corelibs-xctest";
    platforms = with lib.platforms; darwin ++ linux ++ windows;
    license = lib.licenses.asl20;
    maintainers = lib.teams.swift.members;
  };
})
