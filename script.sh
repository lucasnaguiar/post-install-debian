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
echo ">>> (1/8) Atualizando o sistema e os pacotes..."
apt update && apt upgrade -y


# --- 2. Instalação de Pacotes via APT ---
echo ">>> (2/8) Instalando pacotes essenciais via APT..."
apt install -y \
    curl git zsh i3 i3blocks rofi zip unzip neovim chromium \
    fonts-firacode fonts-font-awesome fonts-jetbrains-mono \
    vlc qbittorrent filezilla gimp inkscape vokoscreen-ng \
    bluez bluez-tools blueman \
    flatpak btop paper-icon-theme thunar


# --- 3. Configuração do Flatpak ---
echo ">>> (3/8) Configurando o repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo ">>> (3/8) Instalando aplicativos via Flatpak..."
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.github.johnfactotum.Foliate
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub com.spotify.Client


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


# --- 6. Instalação de Aplicativos Manuais ---
echo ">>> (6/8) Instalando aplicativos manuais (Postman, IntelliJ IDEA)..."

# Postman
echo "Instalando Postman..."
wget -qO /tmp/postman.tar.gz "https://dl.pstmn.io/download/latest/linux64"
tar -xzf /tmp/postman.tar.gz -C /opt
rm /tmp/postman.tar.gz
mv /opt/Postman /opt/postman

# Cria o atalho .desktop para o Postman
cat << EOF > /home/$REAL_USER/.local/share/applications/postman.desktop
[Desktop Entry]
Name=Postman
GenericName=API Client
Comment=Make and view REST API calls and responses
Exec=/opt/postman/Postman
Terminal=false
Type=Application
Icon=/opt/postman/app/resources/app/assets/icon.png
Categories=Development;Utilities;
StartupWMClass=Postman
EOF

# IntelliJ IDEA Community Edition
echo "Instalando IntelliJ IDEA..."
# Usando o link permanente para a versão estável mais recente
wget -qO /tmp/idea.tar.gz "https://download.jetbrains.com/idea/ideaIU-latest.tar.gz"
tar -xzf /tmp/idea.tar.gz -C /opt
rm /tmp/idea.tar.gz
# Encontra o nome da pasta extraída, que muda a cada versão
IDEA_DIR_NAME=$(find /opt -maxdepth 1 -type d -name "idea-IU-*")
mv "$IDEA_DIR_NAME" /opt/idea

# Cria o atalho .desktop para o IntelliJ IDEA
cat << EOF > /home/$REAL_USER/.local/share/applications/idea.desktop
[Desktop Entry]
Name=IntelliJ IDEA
GenericName=Integrated Development Environment
Comment=Java IDE
Exec=/opt/idea/bin/idea.sh
Terminal=false
Type=Application
Icon=/opt/idea/bin/idea.svg
Categories=Development;Utilities;
StartupWMClass=jetbrains-idea
EOF

# Ajusta as permissões dos arquivos .desktop
chown $REAL_USER:$REAL_USER /home/$REAL_USER/.local/share/applications/postman.desktop
chown $REAL_USER:$REAL_USER /home/$REAL_USER/.local/share/applications/idea.desktop


# --- 7. Configuração Final do Ambiente ---
echo ">>> (7/8) Definindo Zsh como o shell padrão para o usuário $REAL_USER..."
chsh -s "$(which zsh)" "$REAL_USER"


#TODO
# nvm, greenclip

# --- 8. Finalização ---
echo ""
echo ">>> (8/8) Instalação concluída com sucesso!"
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

