#!/bin/bash

# Script para instalar o Visual Studio Code no Debian seguindo as recomendações da Microsoft

# Garante que o script seja executado com privilégios de superusuário (root)
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Use: sudo ./instalar_vscode.sh" >&2
  exit 1
fi

# 1. Atualiza o índice de pacotes e instala as dependências necessárias
echo ">>> Instalando dependências (wget, gpg, apt-transport-https)..."
apt-get update
apt-get install -y wget gpg apt-transport-https

# 2. Baixa a chave GPG da Microsoft, a converte e a instala no diretório de chaves
echo ">>> Adicionando a chave do repositório da Microsoft..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg

# Verifica se a chave foi criada com sucesso
if [ ! -f "/usr/share/keyrings/microsoft-archive-keyring.gpg" ]; then
    echo "Falha ao baixar ou criar a chave GPG da Microsoft. Abortando." >&2
    exit 1
fi

# 3. Cria o arquivo de lista de fontes para o VS Code
echo ">>> Configurando o repositório do VS Code..."
echo "Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft-archive-keyring.gpg" > /etc/apt/sources.list.d/vscode.sources

# 4. Atualiza o índice de pacotes novamente para incluir o repositório do VS Code
echo ">>> Atualizando a lista de pacotes..."
apt-get update

# 5. Instala o Visual Studio Code (versão estável)
echo ">>> Instalando o Visual Studio Code..."
apt-get install -y code

echo ""
echo ">>> Instalação do Visual Studio Code concluída com sucesso!"
echo ">>> Você pode iniciá-lo procurando por 'Visual Studio Code' no seu menu de aplicativos ou executando 'code' no terminal."

exit 0