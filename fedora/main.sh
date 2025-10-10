#!/bin/bash

# ===================================================================================
# Script de Pós-Instalação para Fedora
#
# Este script automatiza a instalação de pacotes e ferramentas de desenvolvimento
# para o usuário 'lucas'.
#
# Como usar:
# 1. Revise as variáveis na seção 'Configurações'.
# 2. Salve este arquivo como 'post_install_fedora.sh'.
# 3. Dê permissão de execução: chmod +x post_install_fedora.sh
# 4. Execute com sudo: sudo ./post_install_fedora.sh
# ===================================================================================

# --- Configurações ---

# O usuário para o qual as ferramentas de desenvolvimento serão instaladas.
# O script é menos portátil por ter um usuário fixo.
readonly TARGET_USER="lucas"

# --- Funções Auxiliares ---

# Exibe uma mensagem de log formatada.
log() {
    echo -e "\n\n>>> $1\n"
}

# Executa um comando como o usuário alvo.
run_as_user() {
    sudo -u "$TARGET_USER" bash -c "$1"
}

# --- Funções de Instalação ---

# Atualiza o sistema.
update_system() {
    log "Atualizando o sistema e os pacotes..."
    dnf upgrade -y
}

# Instala pacotes via DNF.
install_dnf_packages() {
    log "Instalando pacotes essenciais via DNF..."
    
    # Pacotes essenciais do sistema
    local system_packages=(
        curl git zsh i3 i3blocks rofi zip unzip neovim
        vlc qbittorrent filezilla gimp inkscape
        flatpak btop paper-icon-theme flameshot
    )

    dnf install -y "${system_packages[@]}"
}

# Instala aplicativos via Flatpak.
install_flatpak_apps() {
    log "Configurando o repositório Flathub e instalando aplicativos via Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    local flatpak_apps=(
        com.discordapp.Discord
        com.github.johnfactotum.Foliate
        md.obsidian.Obsidian
        com.spotify.Client
        org.kde.ghostwriter
    )

    for app in "${flatpak_apps[@]}"; do
        flatpak install -y flathub "$app"
    done
}

# Instala o Google Chrome.
install_google_chrome() {
    log "Instalando Google Chrome..."
    # O Chromium foi removido da lista de pacotes DNF para evitar redundância.
    dnf install -y 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm'
}

# Instala ferramentas de desenvolvimento.
install_developer_tools() {
    log "Instalando ferramentas de desenvolvimento para o usuário '$TARGET_USER'ப்பான..."

    log "Instalando Oh My Zsh..."
    run_as_user "sh -c \"$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"

    log "Instalando NVM (Node Version Manager)..."
    run_as_user "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash"

    log "Instalando Node.js v22..."
    run_as_user 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install 22 && nvm use 22 && nvm alias default 22'

    log "Instalando ferramentas de IA..."
    run_as_user 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g @anthropic-ai/claude-code && npm install -g @google/gemini-cli'

    log "Instalando SDKMAN..."
    run_as_user 'curl -s "https://get.sdkman.io" | bash'
}

# Configura o ambiente final.
configure_final_environment() {
    log "Definindo Zsh como o shell padrão para o usuário '$TARGET_USER'..."
    chsh -s "$(which zsh)" "$TARGET_USER"
}

# --- Função Principal ---

main() {
    # Verificações iniciais
    if [ "$EUID" -ne 0 ]; then
        echo "Por favor, execute este script como root (usando sudo)."
        exit 1
    fi

    set -e

    update_system
    install_dnf_packages
    install_flatpak_apps
    install_google_chrome
    install_developer_tools
    configure_final_environment

    log "Instalação concluída com sucesso!"
    echo "----------------------------------------------------------------"
    echo "  AÇÃO NECESSÁRIA:  "
    echo "----------------------------------------------------------------"
    echo "O Zsh foi definido como seu shell padrão."
    echo ""
    echo "Para que todas as alterações (novo shell, NVM, SDKMAN) tenham"
    echo "efeito completo, por favor, FAÇA LOGOUT E LOGIN NOVAMENTE"
    echo "ou reinicie o computador."
    echo "----------------------------------------------------------------"
}

# --- Execução ---

main
