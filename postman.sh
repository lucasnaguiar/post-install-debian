#!/bin/bash

# Postman
echo "Instalando Postman..."
wget -qO /tmp/postman.tar.gz "https://dl.pstmn.io/download/latest/linux64"
tar -xzf /tmp/postman.tar.gz -C /opt
rm /tmp/postman.tar.gz
mv /opt/Postman /opt/postman

# Cria o atalho .desktop para o Postman
cat << EOF > /home/$REAL_USER/.local/share/applications/postman.desktop
[Desktop Entry]
Name=Postman
GenericName=API Client
Comment=Make and view REST API calls and responses
Exec=/opt/postman/Postman
Terminal=false
Type=Application
Icon=/opt/postman/app/resources/app/assets/icon.png
Categories=Development;Utilities;
StartupWMClass=Postman
EOF

# Ajusta as permissões dos arquivos .desktop
chown $REAL_USER:$REAL_USER /home/$REAL_USER/.local/share/applications/postman.desktop