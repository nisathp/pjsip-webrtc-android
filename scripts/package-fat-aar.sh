#!/usr/bin/env bash
set -euo pipefail

# Combines one single-ABI PJSUA2 AAR from each matrix job into one Android AAR.
INPUT_DIR="${1:?Usage: package-fat-aar.sh <downloaded-artifact-directory> <output-aar>}"
OUTPUT_AAR="${2:?Usage: package-fat-aar.sh <downloaded-artifact-directory> <output-aar>}"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

mapfile -t AARS < <(find "${INPUT_DIR}" -name 'pjsip-webrtc-aec3-*.aar' -type f | sort)
if [[ ${#AARS[@]} -eq 0 ]]; then
  echo "No per-ABI AAR files found in ${INPUT_DIR}" >&2
  exit 1
fi

for aar in "${AARS[@]}"; do
  unpack_dir="${WORK_DIR}/$(basename "${aar}" .aar)"
  mkdir -p "${unpack_dir}"
  unzip -q "${aar}" -d "${unpack_dir}"

  if [[ ! -f "${WORK_DIR}/classes.jar" ]]; then
    cp "${unpack_dir}/classes.jar" "${WORK_DIR}/classes.jar"
    cp "${unpack_dir}/AndroidManifest.xml" "${WORK_DIR}/AndroidManifest.xml"
    [[ -f "${unpack_dir}/R.txt" ]] && cp "${unpack_dir}/R.txt" "${WORK_DIR}/R.txt"
    [[ -f "${unpack_dir}/proguard.txt" ]] && cp "${unpack_dir}/proguard.txt" "${WORK_DIR}/proguard.txt"
  fi

  if [[ -d "${unpack_dir}/jni" ]]; then
    cp -R "${unpack_dir}/jni" "${WORK_DIR}/"
  fi
done

mkdir -p "$(dirname "${OUTPUT_AAR}")"
pushd "${WORK_DIR}" >/dev/null
zip -qr "${OUTPUT_AAR}" .
popd >/dev/null
