#!/usr/bin/env bash
set -euo pipefail

# Builds PJSIP 2.16's bundled WebRTC AEC3 and the official PJSUA2 Android AAR
# for one Android ABI. GitHub Actions sets ANDROID_NDK_ROOT and TARGET_ABI.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PJSIP_DIR="${ROOT_DIR}/third_party/pjproject"
ABI="${TARGET_ABI:-arm64-v8a}"
API="${ANDROID_API:-24}"

: "${ANDROID_NDK_ROOT:?Set ANDROID_NDK_ROOT to an installed Android NDK}"

if [[ ! -x "${PJSIP_DIR}/configure-android" ]]; then
  echo "PJSIP submodule is missing. Run: git submodule update --init --recursive" >&2
  exit 1
fi

export APP_PLATFORM="android-${API}"
export TARGET_ABI="${ABI}"
export CFLAGS="${CFLAGS:-}"
export CXXFLAGS="${CXXFLAGS:-}"
export LDFLAGS="${LDFLAGS:-}"

cp "${ROOT_DIR}/config/pj-config-site.h" "${PJSIP_DIR}/pjlib/include/pj/config_site.h"

pushd "${PJSIP_DIR}" >/dev/null
./configure-android \
  --use-ndk-cflags \
  --enable-shared \
  --enable-libwebrtc-aec3 \
  --disable-video

make dep
make -j"$(getconf _NPROCESSORS_ONLN)"

pushd pjsip-apps/src/swig/java >/dev/null
# The upstream SWIG Makefile generates Java sources as a side effect of the
# native target but does not declare that relationship to its Java targets.
# Keep this invocation serial so Java compilation cannot race source creation.
make

pushd android >/dev/null
./gradlew --no-daemon :pjsua2:assembleRelease

OUT_DIR="${ROOT_DIR}/dist/${ABI}"
mkdir -p "${OUT_DIR}"
cp pjsua2/build/outputs/aar/pjsua2-release.aar "${OUT_DIR}/pjsip-webrtc-aec3-${ABI}.aar"
popd >/dev/null
popd >/dev/null
popd >/dev/null
