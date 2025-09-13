#!/bin/bash

# Script para configurar as informações globais de usuário do Git.

# Verifica primeiro se o Git está instalado
if ! command -v git &> /dev/null
then
    echo "Git não foi encontrado. Por favor, instale o Git antes de executar este script."
    echo "Use, por exemplo: sudo apt install git"
    exit 1
fi

# Solicita as informações do usuário
echo ">>> Configuração do Git - Informe seus dados:"
echo ""
read -p "Digite seu nome completo: " GIT_USER_NAME
read -p "Digite seu email: " GIT_USER_EMAIL

echo ""
echo ">>> Configurando o Git com as seguintes informações:"
echo "Nome:  $GIT_USER_NAME"
echo "Email: $GIT_USER_EMAIL"
echo ""

# Executa os comandos de configuração global
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

echo "-----------------------------------------------------------"
echo "✅ Configuração do Git concluída com sucesso!"
echo ""
echo ">>> Verificando as configurações globais salvas:"
git config --global --list | grep 'user.name'
git config --global --list | grep 'user.email'
echo "-----------------------------------------------------------"

exit 0