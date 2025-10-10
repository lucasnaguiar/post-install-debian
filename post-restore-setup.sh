#!/usr/bin/env bash
set -e

# ================================
# Post-Restore Setup Script - Lucas
# ================================
# Este script instala o NVM, Node.js v22, suas AIs globais,
# alguns aplicativos Flatpak e configura o greenclip como serviço systemd.

# 🧰 Função para exibir mensagens destacadas
log() {
    echo -e "\n\033[1;32m==> $1\033[0m\n"
}

# 1. Instalar dependências básicas
log "Instalando dependências básicas..."
sudo apt update -y
sudo apt install -y curl flatpak neovim

# 2. Instalar NVM
log "Instalando NVM..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
    log "NVM já está instalado, pulando..."
fi

# Carregar NVM no shell atual
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. Instalar Node.js v22
log "Instalando Node.js v22..."
nvm install 22
nvm use 22
nvm alias default 22

# 4. Instalar AIs globais
log "Instalando ferramentas de IA..."
npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli

# 5. Instalar aplicativos Flatpak
log "Instalando Flatpaks..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.spotify.Client
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub org.kde.ghostwriter
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub org.telegram.desktop

# 6. Criar e habilitar serviço do Greenclip
log "Configurando serviço do Greenclip..."
GREENCLIP_SERVICE="/etc/systemd/system/greenclip.service"

sudo bash -c "cat > $GREENCLIP_SERVICE" <<EOF
[Unit]
Description=Greenclip Daemon
After=network.target

[Service]
ExecStart=/usr/bin/greenclip daemon
Restart=always
User=$USER
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable greenclip.service
sudo systemctl start greenclip.service

log "Verificando status do serviço Greenclip..."
sudo systemctl status greenclip.service --no-pager

log "✅ Instalação concluída com sucesso!"
