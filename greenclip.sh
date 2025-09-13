#!/bin/bash

# Script para instalar e configurar o Greenclip

# Variáveis
GREENCLIP_URL="https://github.com/erebe/greenclip/releases/download/v4.2/greenclip"
GREENCLIP_BIN_NAME="greenclip"
INSTALL_DIR="/usr/bin"
CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/greenclip.toml"
CACHE_FILE_PATH="$HOME/.cache/greenclip.history"

# --- INÍCIO DA INSTALAÇÃO ---

echo ">>> Iniciando a instalação do Greenclip..."

# 1. Baixar o binário do Greenclip
echo ">>> Baixando o Greenclip de $GREENCLIP_URL..."
wget -O "$GREENCLIP_BIN_NAME" "$GREENCLIP_URL"

# Verifica se o download foi bem-sucedido
if [ $? -ne 0 ]; then
    echo "Erro ao baixar o Greenclip. Verifique sua conexão com a internet ou a URL." >&2
    exit 1
fi

# 2. Dar permissão de execução
echo ">>> Concedendo permissão de execução..."
chmod +x "$GREENCLIP_BIN_NAME"

# 3. Mover o binário para /usr/bin (requer sudo)
echo ">>> Movendo o binário para $INSTALL_DIR..."
echo "Será solicitada a senha de superusuário (sudo) para mover o arquivo."
if sudo mv "$GREENCLIP_BIN_NAME" "$INSTALL_DIR/"; then
    echo ">>> Greenclip instalado com sucesso em $INSTALL_DIR/$GREENCLIP_BIN_NAME"
else
    echo "Erro ao mover o arquivo para $INSTALL_DIR. A instalação falhou." >&2
    # Remove o arquivo baixado se a movimentação falhar
    rm "$GREENCLIP_BIN_NAME"
    exit 1
fi

# --- INÍCIO DA CONFIGURAÇÃO ---

echo ">>> Configurando o arquivo greenclip.toml..."

# 4. Criar o diretório de configuração se não existir
if [ ! -d "$CONFIG_DIR" ]; then
    echo ">>> Criando o diretório de configuração em $CONFIG_DIR..."
    mkdir -p "$CONFIG_DIR"
fi

# 5. Criar o arquivo de configuração com o caminho do usuário dinâmico
# Usamos a variável $HOME que é a maneira mais segura de obter o diretório home do usuário que executa o script.
echo ">>> Criando o arquivo de configuração em $CONFIG_FILE..."
cat > "$CONFIG_FILE" << EOL
[greenclip]
  history_file = "$CACHE_FILE_PATH"
  max_history_length = 50
  max_selection_size_bytes = 0
  trim_space_from_selection = true
  use_primary_selection_as_input = false
  blacklisted_applications = []
  enable_image_support = true
  image_cache_directory = "/tmp/greenclip"
  static_history = [
 '''¯\_(ツ)_/¯''',
]
EOL

# Verifica se o arquivo de configuração foi criado
if [ -f "$CONFIG_FILE" ]; then
    echo ">>> Arquivo de configuração criado com sucesso!"
else
    echo "Erro ao criar o arquivo de configuração." >&2
    exit 1
fi

echo ""
echo ">>> Instalação e configuração do Greenclip concluídas!"

exit 0