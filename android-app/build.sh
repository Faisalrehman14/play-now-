#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$APP_ROOT/.." && pwd)"
SDK="${ANDROID_HOME:-/home/fiasal/Android/Sdk}"
BT="$SDK/build-tools/35.0.0"
ANDROID_JAR="$SDK/platforms/android-34/android.jar"
JAVA_HOME="${JAVA_HOME:-/home/fiasal/.antigravity/extensions/redhat.java-1.55.0-linux-x64/jre/21.0.11-linux-x86_64}"
export JAVA_HOME
PATH="$JAVA_HOME/bin:$BT:$PATH"

SRC="$APP_ROOT/app/src/main"
WORK="$APP_ROOT/build"
GEN="$WORK/gen"
CLASSES="$WORK/classes"
OUT="$WORK/out"

rm -rf "$WORK"
mkdir -p "$GEN" "$CLASSES" "$OUT/compiled"

python3 "$APP_ROOT/make_icons.py"

"$BT/aapt2" compile --dir "$SRC/res" -o "$OUT/compiled/"
mapfile -t FLATS < <(find "$OUT/compiled" -name '*.flat' | sort)
"$BT/aapt2" link \
  -o "$OUT/unaligned.apk" \
  -I "$ANDROID_JAR" \
  --manifest "$SRC/AndroidManifest.xml" \
  --java "$GEN" \
  --auto-add-overlay \
  "${FLATS[@]}"

: > "$WORK/sources.txt"
while IFS= read -r f; do
  printf '"%s"\n' "$f" >> "$WORK/sources.txt"
done < <(find "$SRC/java" "$GEN" -name '*.java')
cp "$WORK/sources.txt" /tmp/vegas-javac-sources.txt

"$JAVA_HOME/bin/javac" \
  --release 17 \
  -classpath "$ANDROID_JAR" \
  -d "$CLASSES" \
  @/tmp/vegas-javac-sources.txt

mapfile -t CLASS_FILES < <(find "$CLASSES" -name '*.class')
"$BT/d8" \
  --min-api 21 \
  --lib "$ANDROID_JAR" \
  --output "$OUT" \
  "${CLASS_FILES[@]}"

# Insert classes.dex into the apk (zip)
cp "$OUT/unaligned.apk" "$OUT/with-dex.apk"
(
  cd "$OUT"
  zip -q with-dex.apk classes.dex
)

"$BT/zipalign" -f -p 4 "$OUT/with-dex.apk" "$OUT/aligned.apk"

"$BT/apksigner" sign \
  --ks "$HOME/.android/debug.keystore" \
  --ks-pass pass:android \
  --key-pass pass:android \
  --ks-key-alias androiddebugkey \
  --out "$OUT/vegasSweeps.apk" \
  "$OUT/aligned.apk"

mkdir -p "$PROJECT_ROOT/download"
cp "$OUT/vegasSweeps.apk" "$PROJECT_ROOT/download/vegasSweeps.apk"
echo "APK ready: $PROJECT_ROOT/download/vegasSweeps.apk"
ls -lh "$PROJECT_ROOT/download/vegasSweeps.apk"
