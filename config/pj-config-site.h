/*
 * Project-wide PJSIP configuration for Android.
 *
 * WebRTC AEC3 itself is enabled by configure-android through
 * --enable-libwebrtc-aec3.  This header intentionally keeps the public
 * defaults small and mobile-oriented.
 */
#ifndef PJSIP_WEBRTC_ANDROID_CONFIG_SITE_H
#define PJSIP_WEBRTC_ANDROID_CONFIG_SITE_H

#define PJSUA_MAX_CALLS 8
#define PJMEDIA_HAS_VIDEO 0
#define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 0

#endif
