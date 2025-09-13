#!/bin/bash

# Script para automatizar a instalação do Docker e Docker Compose em sistemas Debian.
# Baseado na documentação oficial do Docker.

# --- 1. Verificação Inicial ---
# O script precisa ser executado com privilégios de root.
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Por favor, use: sudo ./instalar_docker.sh" >&2
  exit 1
fi

# Identifica o usuário que executou o sudo para adicioná-lo ao grupo 'docker' corretamente.
REAL_USER="${SUDO_USER:-$(whoami)}"

echo "🐳 Iniciando a instalação completa do Docker..."

# --- 2. Configuração do Repositório Docker ---
echo ">>> [Passo 1 de 4] Configurando o repositório do Docker..."
# Atualiza a lista de pacotes e instala dependências para usar repositórios HTTPS.
apt-get update
apt-get install -y ca-certificates curl

# Cria o diretório para as chaves do apt se não existir.
install -m 0755 -d /etc/apt/keyrings

# Adiciona a chave GPG oficial do Docker.
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker às fontes do Apt.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes novamente com o novo repositório.
apt-get update

# --- 3. Instalação dos Pacotes Docker ---
echo ">>> [Passo 2 de 4] Instalando os pacotes do Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verifica se a instalação foi bem-sucedida
if ! command -v docker &> /dev/null; then
    echo "A instalação do Docker falhou. Abortando." >&2
    exit 1
fi

# --- 4. Configuração Pós-instalação ---
echo ">>> [Passo 3 de 4] Executando configurações pós-instalação..."

# Cria o grupo 'docker' se ele não existir.
if ! getent group docker >/dev/null; then
    echo "Criando o grupo 'docker'..."
    groupadd docker
else
    echo "O grupo 'docker' já existe."
fi

# Adiciona o usuário atual ao grupo 'docker'.
echo "Adicionando o usuário '$REAL_USER' ao grupo 'docker'..."
usermod -aG docker "$REAL_USER"

# Habilita os serviços do Docker e Containerd para iniciarem com o sistema.
echo "Habilitando os serviços do Docker..."
systemctl enable docker.service
systemctl enable containerd.service

# --- 5. Instruções Finais ---
echo ""
echo "--------------------------------------------------------------------"
echo "✅ [Passo 4 de 4] Instalação do Docker concluída com sucesso!"
echo ""
echo "🔴 AÇÃO NECESSÁRIA:"
echo "Para que a permissão de grupo tenha efeito, você precisa:"
echo "1. Fazer logout e login novamente na sua sessão, OU"
echo "2. Executar o comando 'newgrp docker' no seu terminal."
echo ""
echo "Depois disso, você poderá executar comandos Docker sem usar 'sudo'."
echo "Teste a instalação com o comando: docker run hello-world"
echo "--------------------------------------------------------------------"

exit 0