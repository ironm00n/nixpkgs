{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  swift-no-testing,
  swift-syntax,
  swift_release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-testing";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-testing";
    tag = "swift-${finalAttrs.version}-RELEASE";
    hash = "sha256-445tgO3jF1ZILoSNosYtn2RN+5gYA1QRXaznNXLzans=";
  };

  patches = [ ./patches/0001-gnu-install-dirs.patch ];

  postPatch = ''
    # Need to reference $include, so this can’t be substituted by `replaceVars`.
    substituteInPlace CMakeLists.txt --replace-fail '@include@' "''${!outputInclude}"
  '';

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic)) ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift-no-testing
  ];

  buildInputs = [ swift-syntax ];

  __structuredAttrs = true;

  meta = { }; # TODO: Fill in `meta` information
})
