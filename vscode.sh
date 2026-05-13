#!/bin/bash

# Script para instalar o Visual Studio Code no Fedora seguindo as recomendações da Microsoft

if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Use: sudo ./vscode.sh" >&2
  exit 1
fi

# 1. Importa a chave GPG da Microsoft
echo ">>> Adicionando a chave do repositório da Microsoft..."
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# 2. Adiciona o repositório do VS Code
echo ">>> Configurando o repositório do VS Code..."
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null

# 3. Instala o Visual Studio Code
echo ">>> Instalando o Visual Studio Code..."
dnf check-update
dnf install -y code

echo ""
echo ">>> Instalação do Visual Studio Code concluída com sucesso!"
echo ">>> Você pode iniciá-lo procurando por 'Visual Studio Code' no seu menu de aplicativos ou executando 'code' no terminal."

exit 0
