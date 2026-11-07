#!/bin/bash
# Compila e installa (solo per l'utente) KRDC con la FreeRDP bloccata alla 3.32.2.
set -euo pipefail
cd "$(dirname "$0")"
flatpak run org.flatpak.Builder --user --install --force-clean --disable-rofiles-fuse \
  --install-deps-from=flathub --state-dir="$HOME/.cache/krdc-fb" build org.kde.krdc.json
