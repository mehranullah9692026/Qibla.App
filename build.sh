#!/usr/bin/env bash
# کپڑے کا حساب: Signed APK اور AAB تیار کریں
set -Eeuo pipefail
cd "$(dirname "$0")"

command -v java >/dev/null 2>&1 || { echo "غلطی: JDK 21 درکار ہے۔"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "غلطی: Node.js 22 درکار ہے۔"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "غلطی: npm درکار ہے۔"; exit 1; }

export ANDROID_HOME="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
[ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ] || {
  echo "غلطی: Android SDK نہیں ملا۔ Android Studio نصب کریں اور ANDROID_HOME سیٹ کریں۔"
  exit 1
}
export ANDROID_SDK_ROOT="$ANDROID_HOME"

export KS_FILE="${KS_FILE:-$PWD/my-release-key.jks}"
if [ -z "${KS_PASS:-}" ]; then
  if [ -t 0 ]; then
    read -rsp "Release key کا مضبوط پاس ورڈ درج کریں: " KS_PASS
    echo
  else
    echo "غلطی: CI میں KS_PASS secret مقرر کریں۔"
    exit 1
  fi
fi
export KS_PASS

if [ ! -f "$KS_FILE" ]; then
  keytool -genkeypair -keystore "$KS_FILE" -alias kapra \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$KS_PASS" -keypass "$KS_PASS" \
    -dname "CN=Kapra Hisab"
  echo "نئی signing key بن گئی۔ اسے اور اس کا پاس ورڈ محفوظ رکھیں۔"
fi

npm install
if [ ! -d android ]; then
  npx cap add android
fi
npx cap sync android

# Capacitor کی بنائی ہوئی Android Gradle فائل میں release signing لگائیں۔
GRADLE_FILE="android/app/build.gradle"
if [ ! -f "$GRADLE_FILE" ]; then
  echo "غلطی: android/app/build.gradle نہیں ملی۔"; exit 1
fi
if ! grep -q "KS_FILE" "$GRADLE_FILE"; then
cat >> "$GRADLE_FILE" <<'GRADLE'

android {
    signingConfigs {
        release {
            storeFile file(System.getenv("KS_FILE"))
            storePassword System.getenv("KS_PASS")
            keyAlias "kapra"
            keyPassword System.getenv("KS_PASS")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
GRADLE
fi

(
  cd android
  chmod +x gradlew
  ./gradlew --no-daemon clean assembleRelease bundleRelease
)

mkdir -p dist
rm -f dist/kapra-hisab.apk dist/kapra-hisab.aab
cp android/app/build/outputs/apk/release/*.apk dist/kapra-hisab.apk
cp android/app/build/outputs/bundle/release/*.aab dist/kapra-hisab.aab
(
  cd dist
  zip -q -j ../kapra-hisab-release.zip kapra-hisab.apk kapra-hisab.aab
)
echo "کامیابی: dist/kapra-hisab.apk"
echo "کامیابی: dist/kapra-hisab.aab"
echo "دونوں فائلوں کی ZIP: kapra-hisab-release.zip"
