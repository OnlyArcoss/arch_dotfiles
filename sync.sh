#!/usr/bin/env bash
# Recopie la conf actuelle du système dans le repo (à lancer avant un commit).
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

for d in hypr waybar wofi kitty mako swayosd fastfetch nwg-look; do
    rm -rf "${REPO:?}/config/$d"
    cp -r "$HOME/.config/$d" "$REPO/config/$d"
done
rm -f "$REPO/config/waybar/config.bak"
cp "$HOME/.config/gtk-3.0/settings.ini" "$REPO/config/gtk-3.0/"
cp "$HOME/.config/gtk-4.0/settings.ini" "$REPO/config/gtk-4.0/"
cp "$HOME/.config/git/ignore" "$REPO/config/git/"

for f in .zshrc .zprofile .gitconfig; do
    cp "$HOME/$f" "$REPO/home/"
done
# Ne jamais versionner de token
sed -i 's|^export NPM_TOKEN=.*|# Secrets (NPM_TOKEN, ...) : dans ~/.zshrc.local, non versionné\n[[ -f ~/.zshrc.local ]] \&\& source ~/.zshrc.local|' "$REPO/home/.zshrc"

for f in system-menu waybar-recorder; do
    cp "$HOME/.local/bin/$f" "$REPO/bin/"
done

# packages/*.txt n'est pas régénéré : c'est le minimum pour la conf, maintenu à la main

echo "Repo synchronisé. Vérifie avec : git -C \"$REPO\" diff"
