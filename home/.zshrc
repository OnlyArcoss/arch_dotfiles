# Emplacement et configuration de l'historique
HISTFILE=~/.zsh_history
HISTSIZE=10000       # Nombre de commandes dans l'historique de session
SAVEHIST=10000       # Nombre de commandes sauvegardées dans le fichier

# Options pour l'historique
setopt appendhistory       # Ajoute les commandes à l'historique au lieu d'écraser
setopt incappendhistory    # Écrit chaque commande dans le fichier d'historique immédiatement
setopt sharehistory        # Partage l'historique entre les sessions ouvertes


#charger starship
eval "$(starship init zsh)"

# Charger zsh-autosuggestions pour des suggestions de commandes
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Charger nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH="$HOME/.local/bin:$PATH"

alias zed='zeditor'

# Secrets (NPM_TOKEN, ...) : dans ~/.zshrc.local, non versionné
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Added by Antigravity CLI installer
export PATH="/home/arcoss/.local/bin:$PATH"
