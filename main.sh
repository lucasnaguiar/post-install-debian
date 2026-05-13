#!/bin/bash

# ===================================================================================
# Script de Pós-Instalação para Fedora
#
# Como usar:
# 1. Dê permissão de execução: chmod +x main.sh
# 2. Execute com sudo: sudo ./main.sh
# ===================================================================================

# --- Verificações Iniciais ---

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute este script como root (usando sudo)."
  exit 1
fi

REAL_USER="lucas"


# --- 1. Atualização do Sistema ---
echo ">>> (1/7) Atualizando o sistema e os pacotes..."
dnf upgrade -y


# --- 2. Instalação de Pacotes via DNF ---
echo ">>> (2/7) Instalando pacotes essenciais via DNF..."
dnf install -y \
    curl git zsh rofi zip unzip neovim chromium \
    vlc qbittorrent filezilla gimp inkscape flameshot \
    flatpak btop gparted jetbrains-mono-fonts gnome-tweaks


# --- 3. Instalação do Google Chrome ---
echo ">>> (3/7) Instalando Google Chrome..."
dnf install -y 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm'


# --- 4. Configuração do Flatpak ---
echo ">>> (4/7) Configurando o repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo ">>> (4/7) Instalando aplicativos via Flatpak..."
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.github.johnfactotum.Foliate
flatpak install -y flathub com.spotify.Client
flatpak install flathub io.github.mfat.sshpilot


# --- 5. Instalação de Ferramentas de Desenvolvimento ---
echo ">>> (5/7) Instalando ferramentas de desenvolvimento para o usuário: $REAL_USER"

echo "Instalando Oh My Zsh..."
sudo -u $REAL_USER sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Instalando NVM..."
sudo -u $REAL_USER bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash'

echo "Instalando Node.js v24..."
sudo -u $REAL_USER bash -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install 24 && nvm use 24 && nvm alias default 24'

echo "Instalando ferramentas de IA (claude-code, gemini-cli)..."
sudo -u $REAL_USER bash -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g @anthropic-ai/claude-code && npm install -g @google/gemini-cli'

echo "Instalando SDKMAN..."
sudo -u $REAL_USER bash -c 'curl -s "https://get.sdkman.io" | bash'


# --- 6. Configuração Final do Ambiente ---
echo ">>> (6/7) Definindo Zsh como o shell padrão para o usuário $REAL_USER..."
chsh -s "$(which zsh)" "$REAL_USER"


# --- 7. Finalização ---
echo ""
echo ">>> (7/7) Instalação concluída com sucesso!"
echo ""
echo "----------------------------------------------------------------"
echo "  AÇÃO NECESSÁRIA:  "
echo "----------------------------------------------------------------"
echo "O Zsh foi definido como seu shell padrão."
echo ""
echo "Para que todas as alterações (novo shell, NVM, SDKMAN) tenham"
echo "efeito completo, por favor, FAÇA LOGOUT E LOGIN NOVAMENTE"
echo "ou reinicie o computador."
echo "----------------------------------------------------------------"
