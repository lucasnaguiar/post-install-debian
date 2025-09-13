#!/bin/bash

# Script para instalar o Node Version Manager (NVM) de forma automatizada.

# Verifica se git e curl/wget estão instalados, pois são necessários para a instalação.
if ! command -v git &> /dev/null; then
    echo "Git não foi encontrado. Por favor, instale o Git primeiro (ex: sudo apt install git)." >&2
    exit 1
fi

if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo "Nem curl nem wget foram encontrados. Por favor, instale um deles (ex: sudo apt install curl)." >&2
    exit 1
fi

# 1. Obter a versão mais recente do NVM para construir a URL de instalação
# Isso garante que estamos sempre usando o script de instalação mais atual.
echo ">>> Verificando a última versão do NVM no GitHub..."
LATEST_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Não foi possível obter a última versão do NVM. Verifique sua conexão ou a API do GitHub." >&2
    exit 1
fi

echo ">>> A última versão encontrada é: $LATEST_VERSION"
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"

# 2. Baixar e executar o script de instalação oficial
echo ">>> Baixando e executando o script de instalação do NVM..."
if command -v curl &> /dev/null; then
    curl -o- "$INSTALL_URL" | bash
else
    wget -qO- "$INSTALL_URL" | bash
fi

# 3. Mensagem de pós-instalação
# O script de instalação do NVM já adiciona as linhas necessárias ao .bashrc, .zshrc, etc.
# Esta mensagem informa ao usuário o que fazer a seguir.
echo ""
echo "-----------------------------------------------------------------------"
echo ">>> NVM instalado com sucesso!"
echo ""
echo ">>> AÇÃO NECESSÁRIA:"
echo ">>> Para começar a usar o nvm, você precisa recarregar a configuração do seu shell."
echo ">>> Feche e reabra seu terminal, ou execute o seguinte comando:"
echo ""
echo "    source ~/.bashrc  (ou ~/.zshrc, ~/.profile, etc.)"
echo ""
echo ">>> Depois disso, você pode verificar a instalação com:"
echo "    command -v nvm"
echo ""
echo ">>> E então instalar a versão mais recente do Node.js com:"
echo "    nvm install node"
echo "-----------------------------------------------------------------------"

exit 0