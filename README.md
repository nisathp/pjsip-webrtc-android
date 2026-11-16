# PJSIP WebRTC AEC3 for Android

An open-source Android AAR build of [PJSIP 2.16](https://github.com/pjsip/pjproject)
with its bundled WebRTC AEC3 echo-cancellation implementation enabled.

## What is included

- PJSIP / PJSUA2 SIP stack
- Bundled WebRTC AEC3, enabled at configure time
- Android ABIs: `armeabi-v7a`, `arm64-v8a`, and `x86_64`
- GitHub Actions build and a universal AAR artifact
- Android API 24 minimum and NDK r28 (16 KB ELF-page compatible)

This is not a full standalone WebRTC media engine. PJSIP owns signaling and
media transport; WebRTC AEC3 is used only for audio processing.

## Downloading a build

Open the latest successful **Build Android PJSIP WebRTC AEC3** Actions run and
download the `pjsip-webrtc-aec3-android` artifact. It contains the universal
`pjsip-webrtc-aec3.aar`.

## Local build

```bash
git clone --recurse-submodules <this-repository-url>
export ANDROID_NDK_ROOT=/path/to/android-ndk-r28
export TARGET_ABI=arm64-v8a
./scripts/build-android.sh
```

The per-ABI AAR is written to `dist/<abi>/`.

## License

This project is intended for GPL-compatible, source-available Android apps.
See [third-party notices](LICENSES/THIRD_PARTY.md) and PJSIP's `COPYING` file
in the submodule before redistribution.
