#!/usr/bin/env bash
# Installe les drivers graphiques, à lancer quand on veut (après install.sh).
#   ./gpu.sh           -> détecte la carte via lspci
#   ./gpu.sh nvidia    -> force un vendeur : nvidia | amd | intel
# Les paquets lib32-* (multilib) servent à Steam / Wine.
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    echo "Ne pas lancer en root : utilise ton utilisateur (avec sudo)." >&2
    exit 1
fi

vendor="${1:-}"
if [ -z "$vendor" ]; then
    gpus="$(lspci -nn | grep -Ei 'vga|3d|display' || true)"
    # NVIDIA en premier : sur un portable hybride c'est elle qui a besoin d'un driver
    if grep -qi nvidia <<< "$gpus"; then vendor=nvidia
    elif grep -qiE 'amd|ati' <<< "$gpus"; then vendor=amd
    elif grep -qi intel <<< "$gpus"; then vendor=intel
    else
        echo "Aucune carte reconnue, précise : ./gpu.sh nvidia|amd|intel" >&2
        exit 1
    fi
    echo "Carte détectée : $vendor"
fi

case "$vendor" in
    nvidia)
        # -dkms + headers : marche avec n'importe quel noyau installé (linux, linux-zen, lts...)
        headers=()
        for f in /usr/lib/modules/*/pkgbase; do
            headers+=("$(cat "$f")-headers")
        done
        pkgs=(nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings libva-nvidia-driver "${headers[@]}")
        ;;
    amd)
        pkgs=(mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon)
        ;;
    intel)
        pkgs=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver)
        ;;
    *)
        echo "Vendeur inconnu : $vendor (nvidia | amd | intel)" >&2
        exit 1
        ;;
esac

if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
fi
sudo pacman -Syu --needed "${pkgs[@]}"

echo "Drivers $vendor installés. Redémarre pour les charger."
