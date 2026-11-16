# Architecture

The library keeps SIP, SDP, ICE, RTP, and SRTP ownership in PJSIP. It enables
PJSIP 2.16's bundled WebRTC AEC3 implementation through
`--enable-libwebrtc-aec3`; it does not add a second full WebRTC media engine.
That avoids duplicate RTP/ICE/DTLS stacks in one call.

The build produces the official PJSUA2 Java API and `libpjsua2.so` for
`armeabi-v7a`, `arm64-v8a`, and `x86_64`. The package job merges these native
libraries into one universal AAR.

Use `PJMEDIA_ECHO_WEBRTC_AEC3` in the PJSUA media configuration when creating
your endpoint to select the AEC3 echo canceller.
