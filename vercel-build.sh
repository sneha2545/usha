#!/usr/bin/env bash
set -euo pipefail

FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/flutter}"

if [[ ! -x "$FLUTTER_ROOT/bin/flutter" ]]; then
  if command -v flutter >/dev/null 2>&1; then
    FLUTTER_BIN="$(command -v flutter)"
    FLUTTER_ROOT="$(cd "$(dirname "$FLUTTER_BIN")/.." && pwd)"
  else
    mkdir -p "$(dirname "$FLUTTER_ROOT")"
    git clone --depth 1 --branch stable \
      https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
  fi
fi

export PATH="$FLUTTER_ROOT/bin:$PATH"

flutter config --enable-web
flutter pub get
flutter build web --release
