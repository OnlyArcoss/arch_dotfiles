#!/usr/bin/env bash
# Déploie les dotfiles du repo vers $HOME.
# Les fichiers existants sont sauvegardés dans ~/.dotfiles-backup-<date> avant d'être remplacés.
#   ./install.sh             -> configs uniquement
#   ./install.sh --packages  -> installe aussi le minimum pour que la conf marche (packages/*.txt)
# Les drivers graphiques ne sont pas installés : à faire soi-même selon la carte.
# Sans clone préalable :
#   curl -fsSL https://raw.githubusercontent.com/OnlyArcoss/arch_dotfiles/main/install.sh | bash -s -- --packages
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    echo "Ne pas lancer en root : utilise ton utilisateur (avec sudo), sur le système installé." >&2
    exit 1
fi

URL="https://github.com/OnlyArcoss/arch_dotfiles.git"
DEST="$HOME/Documents/arch_dotfiles"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Lancé via curl : pas de repo autour du script -> on clone puis on relance depuis le clone.
# stdin est repris sur le terminal pour que pacman / yay puissent poser leurs questions.
if [ ! -f "$REPO/install.sh" ] || [ ! -d "$REPO/config" ]; then
    command -v git >/dev/null || sudo pacman -S --needed --noconfirm git
    if [ -d "$DEST/.git" ]; then
        git -C "$DEST" pull --ff-only
    else
        git clone "$URL" "$DEST"
    fi
    exec bash "$DEST/install.sh" "$@" < /dev/tty
fi

BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

install_packages() {
    sudo pacman -Syu --needed - < "$REPO/packages/pacman.txt"
    if ! command -v yay >/dev/null; then
        local tmp
        tmp="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
    yay -S --needed - < "$REPO/packages/aur.txt"
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

# hyprpaper ne développe pas ~ : on met le vrai chemin du home
sed -i "s|~/|$HOME/|g" "$HOME/.config/hypr/hyprpaper.conf"

# zsh en shell de login, sinon .zprofile (lancement de Hyprland) n'est jamais lu
if command -v zsh >/dev/null && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    echo "Passage du shell à zsh :"
    chsh -s "$(command -v zsh)"
fi

# Navigateur par défaut (remplace l'ancien mimeapps.list versionné)
xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true

echo "Wallpapers :"
mkdir -p "$HOME/Documents/wallpapers"
cp -n "$REPO"/wallpapers/* "$HOME/Documents/wallpapers/"

# GTK4 : liens vers le thème Colloid (recréés par nwg-look normalement)
THEME=/usr/share/themes/Colloid-Purple-Dark/gtk-4.0
if [ -d "$THEME" ]; then
    ln -sf "$THEME/assets" "$THEME/gtk.css" "$THEME/gtk-dark.css" "$HOME/.config/gtk-4.0/"
fi

[ -d "$BACKUP" ] && echo "Anciens fichiers sauvegardés dans $BACKUP"
echo "Terminé. Drivers graphiques : à installer selon ta carte."
echo "Pense à créer ~/.zshrc.local pour les secrets (NPM_TOKEN...)."
