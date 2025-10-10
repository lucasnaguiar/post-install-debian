#!/usr/bin/env bash
set -e

FONT_URL="https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip"
TMP_DIR="$(mktemp -d)"
FONT_ZIP="$TMP_DIR/ubuntu-font.zip"

# Detecta diretório de fontes do usuário ou do sistema
if [ "$(id -u)" -eq 0 ]; then
    FONT_DIR="/usr/local/share/fonts/ubuntu"
else
    FONT_DIR="$HOME/.local/share/fonts/ubuntu"
fi

echo "📦 Baixando fonte Ubuntu..."
wget -q -O "$FONT_ZIP" "$FONT_URL"

echo "📂 Extraindo para diretório temporário..."
unzip -qq "$FONT_ZIP" -d "$TMP_DIR/fonts"

echo "📁 Instalando fontes em: $FONT_DIR"
mkdir -p "$FONT_DIR"
cp -r "$TMP_DIR/fonts/"* "$FONT_DIR/"

echo "🧹 Limpando arquivos temporários..."
rm -rf "$TMP_DIR"

echo "🔄 Atualizando cache de fontes..."
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv > /dev/null
else
    echo "⚠️  fc-cache não encontrado. Instale o pacote 'fontconfig'."
fi

echo "✅ Fonte Ubuntu instalada com sucesso!"
