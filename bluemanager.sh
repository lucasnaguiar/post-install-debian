#!/bin/bash
set -e

echo "=== Configurando bluetoothd (nível de sistema) ==="
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "=== Criando diretório para serviços do usuário ==="
mkdir -p ~/.config/systemd/user

SERVICE_FILE=~/.config/systemd/user/blueman-applet.service

echo "=== Criando serviço blueman-applet ==="
cat > "$SERVICE_FILE" << 'EOF'
[Unit]
Description=Blueman Applet
After=graphical.target

[Service]
ExecStart=/usr/bin/blueman-applet
Restart=on-failure

[Install]
WantedBy=default.target
EOF

echo "=== Recarregando systemd (user) ==="
systemctl --user daemon-reload

echo "=== Habilitando blueman-applet ==="
systemctl --user enable blueman-applet.service

echo "=== Iniciando blueman-applet ==="
systemctl --user start blueman-applet.service

echo "=== Feito! Verifique o status com: systemctl --user status blueman-applet.service ==="
