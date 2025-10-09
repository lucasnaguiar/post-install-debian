#!/bin/bash

# ===================================================================================
# Script de Pós-Instalação para Debian e Derivados
#
# Este script automatiza a instalação de pacotes e ferramentas de desenvolvimento
# com base em uma lista de comandos fornecida.
#
# Como usar:
# 1. Salve este arquivo como 'post_install_debian.sh'
# 2. Dê permissão de execução: chmod +x post_install_debian.sh
# 3. Execute com sudo: sudo ./post_install_debian.sh
# ===================================================================================

# --- Verificações Iniciais ---

# Aborta o script se qualquer comando falhar
set -e

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute este script como root (usando sudo)."
  exit 1
fi

# Pega o nome do usuário que invocou o sudo, para instalações específicas do usuário
REAL_USER=$SUDO_USER
if [ -z "$REAL_USER" ]; then
    echo "AVISO: Não foi possível determinar o usuário original. Algumas configurações podem precisar ser feitas manualmente."
fi


# --- 1. Atualização do Sistema ---
echo ">>> (1/7) Atualizando o sistema e os pacotes..."
apt update && apt upgrade -y


# --- 2. Instalação de Pacotes via APT ---
echo ">>> (2/8) Instalando pacotes essenciais via APT..."
apt install -y \
    curl git zsh i3 i3blocks rofi arandr zip unzip neovim chromium \
    fonts-firacode fonts-font-awesome fonts-jetbrains-mono \
    vlc qbittorrent filezilla gimp inkscape vokoscreen-ng \
    flatpak btop paper-icon-theme lxappearance nitrogen flameshot


# --- 3. Configuração do Flatpak ---
echo ">>> (3/8) Configurando o repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo ">>> (3/8) Instalando aplicativos via Flatpak..."
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.github.johnfactotum.Foliate
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub com.spotify.Client
flatpak install flathub org.kde.ghostwriter

# --- 4. Instalação de Pacotes .deb e de Fontes Externas ---
echo ">>> (4/8) Instalando Google Chrome..."
wget -qO /tmp/google-chrome-stable.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
apt install -y /tmp/google-chrome-stable.deb
rm /tmp/google-chrome-stable.deb


# --- 5. Instalação de Ferramentas de Desenvolvimento (para o usuário) ---
echo ">>> (5/8) Instalando ferramentas de desenvolvimento para o usuário: $REAL_USER"

# Instala Oh My Zsh
# A flag --unattended previne que o script pare e tente mudar para o shell zsh
echo "Instalando Oh My Zsh..."
sudo -u $REAL_USER sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instala NVM (Node Version Manager)
echo "Instalando NVM..."
sudo -u $REAL_USER bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash'

# Instala SDKMAN
echo "Instalando SDKMAN..."
sudo -u $REAL_USER bash -c 'curl -s "https://get.sdkman.io" | bash'





# --- 6. Configuração Final do Ambiente ---
echo ">>> (6/7) Definindo Zsh como o shell padrão para o usuário $REAL_USER..."
chsh -s "$(which zsh)" "$REAL_USER"


#TODO
# nvm, greenclip

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

