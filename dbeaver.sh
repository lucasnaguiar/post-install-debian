#!/bin/bash

# Script para baixar e instalar a última versão do DBeaver Community Edition
# em sistemas baseados em Debian (Debian, Ubuntu, Mint, etc.).

# --- 1. Verificações Iniciais ---
# Garante que o script seja executado com privilégios de superusuário (root).
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Por favor, use: sudo ./instalar_dbeaver.sh" >&2
  exit 1
fi

# Define as variáveis para o download.
DBEAVER_URL="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
DEB_FILE="dbeaver-ce.deb" # Nome de arquivo local mais simples

echo "🗄️  Iniciando a instalação do DBeaver..."

# --- 2. Instalação de Dependências do Script ---
echo ">>> [Passo 1 de 4] Verificando se o 'wget' está instalado..."
apt-get update > /dev/null
apt-get install -y wget

# --- 3. Download do Pacote .deb ---
echo ">>> [Passo 2 de 4] Baixando o pacote mais recente do DBeaver..."
wget -O "$DEB_FILE" "$DBEAVER_URL"

# Verifica se o download foi bem-sucedido.
if [ $? -ne 0 ]; then
    echo "❌ Erro ao baixar o pacote DBeaver. Verifique sua conexão com a internet ou a URL." >&2
    exit 1
fi

# --- 4. Instalação e Resolução de Dependências ---
echo ">>> [Passo 3 de 4] Instalando DBeaver e resolvendo dependências..."
# Usar 'apt install' com um arquivo .deb local é a forma recomendada,
# pois ele cuida automaticamente da instalação de todas as dependências.
if apt install -y "./$DEB_FILE"; then
    echo ">>> DBeaver foi instalado com sucesso."
else
    echo "❌ A instalação do DBeaver falhou. Verifique as mensagens de erro acima." >&2
    # Limpa o arquivo mesmo em caso de falha.
    rm -f "$DEB_FILE"
    exit 1
fi

# --- 5. Limpeza ---
echo ">>> [Passo 4 de 4] Limpando o arquivo de instalação baixado..."
rm -f "$DEB_FILE"

# --- 6. Confirmação Final ---
echo ""
echo "------------------------------------------------------------------"
# Verifica se o executável 'dbeaver' está disponível no sistema.
if command -v dbeaver &> /dev/null; then
    echo "✅ Verificação concluída! DBeaver está pronto para ser usado."
    echo ">>> Você pode iniciá-lo procurando por 'DBeaver' no menu de aplicativos"
    echo ">>> ou executando o comando 'dbeaver' no seu terminal."
else
    echo "⚠️  A instalação parece ter terminado, mas o comando 'dbeaver' não foi encontrado."
    echo "Pode ter ocorrido um problema inesperado."
fi
echo "------------------------------------------------------------------"

exit 0