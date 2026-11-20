#!/usr/bin/env bash
# Déploie les dotfiles du repo vers $HOME.
# Les fichiers existants sont sauvegardés dans ~/.dotfiles-backup-<date> avant d'être remplacés.
#   ./install.sh             -> configs uniquement
#   ./install.sh --packages  -> installe aussi les paquets pacman / AUR / flatpak
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

install_packages() {
    sudo pacman -S --needed - < "$REPO/packages/pacman.txt"
    if ! command -v yay >/dev/null; then
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && makepkg -si --noconfirm)
    fi
    yay -S --needed - < "$REPO/packages/aur.txt"
    xargs -r flatpak install -y flathub < "$REPO/packages/flatpak.txt"
}

# place <source dans le repo> <destination>
place() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP/$(dirname "${dst#$HOME/}")"
        mv "$dst" "$BACKUP/${dst#$HOME/}"
    fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    echo "  -> $dst"
}

[ "${1:-}" = "--packages" ] && install_packages

echo "Configs (~/.config) :"
for d in "$REPO"/config/*; do
    place "$d" "$HOME/.config/$(basename "$d")"
done

echo "Fichiers du home :"
for f in "$REPO"/home/.[!.]*; do
    place "$f" "$HOME/$(basename "$f")"
done

echo "Scripts (~/.local/bin) :"
for f in "$REPO"/bin/*; do
    place "$f" "$HOME/.local/bin/$(basename "$f")"
    chmod +x "$HOME/.local/bin/$(basename "$f")"
done

echo "Wallpapers :"
mkdir -p "$HOME/Documents/wallpapers"
cp -n "$REPO"/wallpapers/* "$HOME/Documents/wallpapers/"

# GTK4 : liens vers le thème Colloid (recréés par nwg-look normalement)
THEME=/usr/share/themes/Colloid-Purple-Dark/gtk-4.0
if [ -d "$THEME" ]; then
    ln -sf "$THEME/assets" "$THEME/gtk.css" "$THEME/gtk-dark.css" "$HOME/.config/gtk-4.0/"
fi

[ -d "$BACKUP" ] && echo "Anciens fichiers sauvegardés dans $BACKUP"
echo "Terminé. Pense à créer ~/.zshrc.local pour les secrets (NPM_TOKEN...)."
