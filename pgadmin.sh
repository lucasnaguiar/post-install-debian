#!/bin/bash

# Script para instalar o pgAdmin4 em sistemas baseados em Debian.

# 1. Garante que o script seja executado com privilégios de superusuário (root)
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Use: sudo ./instalar_pgadmin.sh" >&2
  exit 1
fi

echo ">>> Iniciando a instalação do pgAdmin4..."

# 2. Instala dependências necessárias (se já não estiverem presentes)
echo ">>> Verificando e instalando dependências (curl, gpg)..."
apt-get update > /dev/null
apt-get install -y curl gpg lsb-release

# 3. Baixa e instala a chave pública para o repositório
echo ">>> Adicionando a chave GPG do repositório do pgAdmin..."
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

# Verifica se a chave foi criada com sucesso
if [ ! -f "/usr/share/keyrings/packages-pgadmin-org.gpg" ]; then
    echo "Falha ao baixar ou criar a chave GPG do pgAdmin. Abortando." >&2
    exit 1
fi

# 4. Cria o arquivo de configuração do repositório
echo ">>> Configurando o repositório do pgAdmin..."
# O comando $(lsb_release -cs) pega o nome da sua versão do SO (ex: bookworm, jammy)
sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

# 5. Atualiza a lista de pacotes para incluir o novo repositório
echo ">>> Atualizando a lista de pacotes..."
apt-get update

# 6. Instala o pacote pgadmin4
echo ">>> Instalando o pgAdmin4 (desktop e web)..."
apt-get install -y pgadmin4

echo ""
echo "-----------------------------------------------------------"
echo "✅ Instalação do pgAdmin4 concluída com sucesso!"
echo "Você pode iniciá-lo procurando por 'pgAdmin 4' no menu de aplicativos."
echo "-----------------------------------------------------------"

exit 0