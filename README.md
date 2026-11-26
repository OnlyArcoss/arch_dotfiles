# arch_dotfiles

Sauvegarde de ma configuration Arch Linux + Hyprland (config en **Lua**, Hyprland 0.57).

- **WM** : Hyprland · **Barre** : Waybar (`waybar-git`) · **Launcher** : Wofi
- **Terminal** : Kitty · **Notifications** : Mako · **OSD volume** : SwayOSD
- **Lock** : Hyprlock · **Wallpaper** : Hyprpaper · **Shell** : Zsh
- **Thème** : Colloid-Purple-Dark (GTK) · icônes Colloid-Purple · curseur Bibata-Modern-Ice · accent `#cba6f7` (Catppuccin Mocha)

---

## Installation

En une commande, sur une machine neuve :

```bash
curl -fsSL https://raw.githubusercontent.com/OnlyArcoss/arch_dotfiles/main/install.sh | bash -s -- --packages   # paquets + configs
curl -fsSL https://raw.githubusercontent.com/OnlyArcoss/arch_dotfiles/main/install.sh | bash                    # configs uniquement
```

Le script clone le repo (HTTPS) dans `~/Documents/arch_dotfiles`, ou le met à jour s'il y est déjà, puis se relance depuis ce clone. Pour pouvoir push ensuite, passer le remote en SSH une fois la clé configurée :

```bash
git -C ~/Documents/arch_dotfiles remote set-url origin git@github.com:OnlyArcoss/arch_dotfiles.git
```

Depuis un clone existant : `./install.sh --packages` ou `./install.sh`.

`install.sh` copie les fichiers du repo dans `$HOME`. Tout fichier existant est d'abord déplacé dans `~/.dotfiles-backup-<date>/`, rien n'est écrasé sans sauvegarde.

Pour mettre le repo à jour depuis la machine :

```bash
./sync.sh            # recopie la conf actuelle + régénère les listes de paquets
git diff             # vérifier
git commit -am "update" && git push
```

---

## Structure du repo / fichiers sauvegardés

| Dans le repo | Emplacement sur le système | Contenu |
|---|---|---|
| `config/hypr/` | `~/.config/hypr/` | `hyprland.lua` + `modules/*.lua`, `hyprlock.conf`, `hyprpaper.conf`, `xdph.conf` |
| `config/waybar/` | `~/.config/waybar/` | `config.jsonc`, `style.css` |
| `config/wofi/` | `~/.config/wofi/` | `config`, `menu.css` (launcher), `dmenu.css` (menu système) |
| `config/kitty/` | `~/.config/kitty/` | `kitty.conf` |
| `config/mako/` | `~/.config/mako/` | `config` |
| `config/swayosd/` | `~/.config/swayosd/` | `config.toml`, `style.css` |
| `config/fastfetch/` | `~/.config/fastfetch/` | `config.jsonc` |
| `config/btop/` | `~/.config/btop/` | `btop.conf` |
| `config/cava/` | `~/.config/cava/` | `config`, thèmes, shaders |
| `config/gtk-3.0/`, `config/gtk-4.0/` | `~/.config/gtk-*/` | `settings.ini` (les `.css` GTK4 sont des liens vers le thème, recréés par `install.sh`) |
| `config/nwg-look/`, `config/xsettingsd/` | `~/.config/…` | réglages du thème GTK |
| `config/git/ignore` | `~/.config/git/ignore` | gitignore global |
| `config/mimeapps.list` | `~/.config/mimeapps.list` | applications par défaut |
| `home/` | `~/` | `.zshrc`, `.zprofile`, `.bashrc`, `.bash_profile`, `.gitconfig` |
| `bin/` | `~/.local/bin/` | scripts perso (voir plus bas) |
| `wallpapers/` | `~/Documents/wallpapers/` | `minimal_landscape.jpg` (utilisé par hyprpaper) |
| `packages/` | — | `pacman.txt`, `aur.txt`, `flatpak.txt` |

> **Secrets** : `.zshrc` charge `~/.zshrc.local` s'il existe. Les tokens (`NPM_TOKEN`, …) vont dans ce fichier, qui n'est **pas** versionné.

---

## Paquets à installer

Listes complètes et à jour dans `packages/` (générées par `pacman -Qqen`, `pacman -Qqem`, `flatpak list`).

### Base système
`base` `base-devel` `linux` `linux-headers` `linux-firmware` `amd-ucode` `grub` `grub-theme-vimix` `efibootmgr` `os-prober` `dkms` `sudo` `zram-generator` `ntfs-3g` `smartmontools` `zip` `unrar` `wget` `tree` `vim` `nano` `git` `openssh`

### NVIDIA
`nvidia-open` `nvidia-settings` `libva-nvidia-driver`

### Hyprland / bureau
`hyprland` `hyprpaper` `hyprpolkitagent` `hyprshot` `xdg-desktop-portal-hyprland` `xdg-utils` `qt5-wayland` `qt6-wayland` `waybar-git` (AUR) `wofi` `mako` `dunst` `swayosd` `kitty` `nwg-look` `grim` `slurp` `wf-recorder` `xorg-server` `xorg-xinit` `polkit-kde-agent` `gnome-keyring` `seahorse`

### Audio / réseau / bluetooth
`pipewire` `pipewire-alsa` `pipewire-jack` `pipewire-pulse` `wireplumber` `gst-plugin-pipewire` `libpulse` `wiremix` · `iwd` `impala` `wireless_tools` `wireguard-tools` `openresolv` `bind` · `bluez` `bluez-utils` `blueman` `bluetui`

### Polices & thèmes
`ttf-jetbrains-mono-nerd` `ttf-dejavu` `noto-fonts` `noto-fonts-cjk` `noto-fonts-emoji` `noto-fonts-extra` `gnome-themes-extra` · AUR : `bibata-cursor-theme-bin` `ttf-ms-fonts`
Thème **Colloid** (GTK + icônes) installé à la main, pas via un paquet :
```bash
git clone https://github.com/vinceliuice/Colloid-gtk-theme && ./Colloid-gtk-theme/install.sh -t purple -c dark
git clone https://github.com/vinceliuice/Colloid-icon-theme && ./Colloid-icon-theme/install.sh -s default -t purple
```

### Terminal / outils
`zsh` `zsh-autosuggestions` `btop` `htop` `fastfetch` `cava` `lazydocker` `yt-dlp` `python-pip` `nvm` `maven` `opencode` `ollama-cuda`

### Dev
`docker` `docker-buildx` `docker-compose` `postgresql` `zed` · AUR : `visual-studio-code-bin` `claude-code` `bruno-git` `postman-bin` `flutter-bin` `infisical-bin` `lunacy-bin`

### Applications
`firefox` `chromium` `discord` `signal-desktop` `obsidian` `keepassxc` `kleopatra` `libreoffice-still` `kdenlive` `mpv` `vlc` `vlc-plugin-chromecast` `vlc-plugin-mdns` `papers` `nautilus` `gnome-boxes` `gnome-disk-utility` `gnome-sound-recorder` `transmission-gtk` `transmission-cli` `steam` `prismlauncher` `v4l2loopback-dkms`
AUR : `brave-bin` `google-chrome` `spotify` `vesktop-bin` `equibop-bin` `localsend` `gale-bin` `iriunwebcam-bin` `droidcam-obs-plugin` `obs-advanced-masks` `xpadneo-dkms` `yay`
Flatpak : `com.hypixel.HytaleLauncher` `org.vinegarhq.Sober`

### Services activés
- système : `docker` `iwd` `systemd-networkd` `systemd-resolved` `bluetooth` `seatd` `fstrim.timer` `systemd-timesyncd`
- utilisateur : `pipewire` `pipewire-pulse` `wireplumber` `gnome-keyring-daemon.socket`

```bash
sudo systemctl enable --now docker iwd systemd-networkd systemd-resolved bluetooth fstrim.timer
```

---

## Configurations appliquées

### Hyprland (`config/hypr/`)
Config modulaire en Lua : `hyprland.lua` ne fait que charger les modules.

| Module | Rôle |
|---|---|
| `monitors.lua` | `HDMI-A-1` 1920x1080@75 en `0x0` · `DP-2` 1920x1080@60 en `1920x-170`. Workspaces 1-9 sur HDMI-A-1, 10 sur DP-2 |
| `env.lua` | curseur Bibata-Modern-Ice 24, GTK dark, `GTK_USE_PORTAL`, `LIBVA_DRIVER_NAME=nvidia` seulement si le module nvidia est chargé |
| `variables.lua` | terminal `kitty`, file manager `dolphin`, menu `wofi` |
| `autostart.lua` | gnome-keyring, waybar, hyprpaper, hyprpolkitagent, swayosd-server |
| `inputs.lua` | clavier `fr`, follow_mouse, sensibilité `-0.5` pour la souris `epic-mouse-v1` |
| `decorations.lua` | gaps 4/8, bordure 2px `#cba6f7` / `#585b70`, rounding 2, ombre, blur (3×2) |
| `animations.lua` | courbes easeOutQuint / almostLinear / quick, popin 87% pour les fenêtres, slide pour les workspaces |
| `rules.lua` | pas de maximize forcé, fix XWayland (fenêtres fantômes), xwaylandvideobridge invisible, kitty à 80% d'opacité, classe `kitty-float` flottante 900x600 centrée |
| `workspace.lua` | dwindle `preserve_split`, master `new_status = master` |

**Raccourcis** (`SUPER` = touche Windows) :

| Raccourci | Action |
|---|---|
| `SUPER + A` | Kitty |
| `SUPER + E` | Gestionnaire de fichiers |
| `SUPER + Espace` | Wofi (launcher) |
| `SUPER + Échap` | Menu système (`system-menu`) |
| `SUPER + C` | Fermer la fenêtre |
| `SUPER + V` | Basculer flottant |
| `SUPER + F` | Plein écran |
| `SUPER + P` / `SUPER + J` | Pseudo-tiling / changer le sens du split |
| `SUPER + L` | Verrouiller (hyprlock) |
| `SUPER + W` | Afficher/masquer waybar (`toggle-waybar.sh`) |
| `SUPER + M` | Quitter Hyprland |
| `SUPER + SHIFT + S` | Capture d'une zone → presse-papier (hyprshot) |
| `SUPER + SHIFT + R` | Enregistrer une zone de l'écran (`waybar-recorder`), clic sur le chrono dans waybar pour arrêter |
| `SUPER + flèches` | Déplacer le focus |
| `SUPER + & é " ' ( - è _ ç à` | Workspace 1 → 10 (AZERTY) |
| `SUPER + SHIFT + (idem)` | Envoyer la fenêtre sur le workspace |
| `SUPER + clic gauche / droit` | Déplacer / redimensionner |
| Touches média | Volume via swayosd, luminosité via brightnessctl, lecture via playerctl |

**Hyprlock** : fond = capture d'écran floutée, heure au-dessus d'un champ de mot de passe centré.
**Hyprpaper** : `~/Documents/wallpapers/minimal_landscape.jpg` sur les deux écrans (+ fallback).
**xdph** : partage d'écran autorisé par défaut, curseur inclus.

### Waybar (`config/waybar/`)
Barre en haut, 26px, sur `HDMI-A-1` uniquement.
- **Gauche** : bouton menu (ouvre `system-menu`) · workspaces (1-5 persistants)
- **Centre** : horloge (`jour HH:MM`, clic → date complète + n° de semaine)
- **Droite** : mpris (lecture en cours) · tray repliable · bluetooth (→ `bluetui`) · VPN WireGuard `afrin` (clic = up/down) · réseau (→ `impala`) · son (→ `wiremix`, clic droit = mute) · CPU (→ `btop`) · batterie

Les applis TUI s'ouvrent dans une fenêtre kitty flottante (`kitty --class kitty-float`).

### Autres
- **Wofi** : launcher 630x400 centré, icônes, insensible à la casse, thème sombre
- **Mako** : notifications en haut à droite sur `DP-2`, JetBrainsMono 10, fond `#1e1e2e`, bordure violette, 4 s
- **Kitty** : FiraCode Nerd Font Mono, fond `#1a1b26`, padding horizontal 12, pas de confirmation à la fermeture
- **SwayOSD** : OSD affiché en bas de l'écran (`top_margin = 0.95`)
- **Zsh** : historique partagé 10 000 lignes, starship, zsh-autosuggestions, nvm, Android SDK, SDKMAN, alias `zed='zeditor'`
- **Login** : `.zprofile` lance Hyprland (`start-hyprland`) automatiquement sur le TTY1

---

## Scripts ajoutés (`bin/` → `~/.local/bin/`)

| Script | Description |
|---|---|
| `system-menu` | Menu Wofi (dmenu) : mise à jour système (`pacman -Syu` + `flatpak update` dans un kitty flottant), redémarrer, éteindre, mettre en veille. Relancer le raccourci ferme le menu s'il est ouvert. Lié à `SUPER + Échap` et au bouton menu de waybar |
| `waybar-recorder` | Enregistrement d'écran d'une zone avec `wf-recorder` + `slurp` → `~/Documents/videos/`. `start` / `stop` / `toggle` / `status` (`status` renvoie du JSON avec la durée, utilisé par le module `custom/recorder` de waybar : icône à côté de l'horloge pour lancer, chrono pendant l'enregistrement, clic pour arrêter) |

---

## Points d'attention

Des choses référencées dans la config mais **absentes du système** au moment de la sauvegarde :

- `hyprlock` (lié à `SUPER + L`), `brightnessctl`, `pamixer` (clic droit son dans waybar), `dolphin` (file manager) ne sont pas installés :
  ```bash
  sudo pacman -S hyprlock brightnessctl pamixer dolphin
  ```
- `starship` est installé à la main dans `/usr/local/bin` (pas via pacman) : `sudo pacman -S starship` sur une nouvelle machine.
- `~/.local/bin/toggle-waybar.sh` (lié à `SUPER + W`) n'existe pas.
- Le module VPN de waybar fait `sudo wg-quick` : il faut une règle sudoers NOPASSWD pour que le clic marche.
- Les noms d'écrans (`HDMI-A-1`, `DP-2`) sont propres à cette machine : à adapter dans `monitors.lua`, `hyprpaper.conf`, `waybar/config.jsonc` et `mako/config` sur une autre machine.
