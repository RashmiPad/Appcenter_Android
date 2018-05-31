#!/bin/bash

# exit if a command fails
set -e

#
# Required parameters
if [ -z "${app_path}" ] ; then
  echo " [!] Missing required input: app_path"
  exit 1
fi
if [ ! -f "${app_path}" ] ; then
  echo " [!] File doesn't exist at specified path: ${app_path}"
  exit 1
fi
if [ -z "${app_center_app}" ] ; then
  echo " [!] Missing required input: app_center_app"
  exit 1
fi
if [ -z "${app_center_token}" ] ; then
  echo " [!] Missing required input: app_center_token"
  exit 1
fi


# ---------------------
# --- Configs:

echo " (i) Provided app path: ${app_path}"
echo " (i) Provided app center app: ${app_center_app}"
echo " (i) Provided app center token: 4f2a6ef04d856c91ce75e01adf03f5af032de65c"
echo "${ANDROID_PROJECT_FOLDER}"



ARTIFACTS_DIR="Artifacts"
BUILD_DIR="Tasky.UITests/bin/Debug"
MANIFEST_PATH="${ARTIFACTS_DIR}/manifest.json"
npm install appcenter-cli@1.0.8 -g
msbuild "Petco.UITests/Petco.UITests.csproj" /p:Configuration=Release


appcenter test prepare uitest --artifacts-dir "${ARTIFACTS_DIR}" --app-path "${app_path}" --build-dir "${BUILD_DIR}" --fixture "Tasky.UITests.Tests(Android)" --debug --quiet

appcenter test run manifest --manifest-path "${MANIFEST_PATH}" --app "${app_center_app}" --devices 3d930114 --test-series "master" --locale "en_US" --debug --quiet --token "${app_center_token}" --async
