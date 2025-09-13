# Post-Install Debian

Scripts de automação para pós-instalação em sistemas Debian 12/13 e derivados.

## Script Principal (main.sh)

O `main.sh` é o script principal que automatiza a instalação de um ambiente básico de desenvolvimento. Deve ser executado como root:

```bash
sudo ./main.sh
```

### Instalações realizadas pelo main.sh:

**Pacotes essenciais via APT:**
- `curl`, `git`, `zsh` - Ferramentas básicas
- `i3`, `i3blocks`, `rofi` - Window manager i3
- `zip`, `unzip`, `neovim` - Utilitários
- `chromium`, Google Chrome - Navegadores
- `fonts-firacode`, `fonts-font-awesome`, `fonts-jetbrains-mono` - Fontes
- `vlc`, `qbittorrent`, `filezilla`, `gimp`, `inkscape`, `vokoscreen-ng` - Aplicações multimídia
- `bluez`, `bluez-tools`, `blueman` - Bluetooth
- `flatpak`, `btop`, `paper-icon-theme`, `thunar`, `lxappearance` - Interface

**Aplicativos via Flatpak:**
- Discord, Foliate, Obsidian, Spotify

**Ferramentas de desenvolvimento:**
- Oh My Zsh (shell personalizado)
- NVM (Node Version Manager)
- SDKMAN (SDK Manager)
- Zsh como shell padrão

## Scripts Opcionais

Execute individualmente conforme necessário:

- **`vscode.sh`** - Instala Visual Studio Code via repositório oficial da Microsoft
- **`node.sh`** - Instala NVM (Node Version Manager) com a versão mais recente
- **`git.sh`** - Configura usuário global do Git (editar nome/email no script)
- **`pgadmin.sh`** - Instala pgAdmin4 para gerenciamento PostgreSQL
- **`postman.sh`** - Instala Postman API client
- **`idea.sh`** - Instala IntelliJ IDEA Ultimate
- **`greenclip.sh`** - Instala Greenclip (gerenciador de clipboard)

## Compatibilidade

Testado em Debian 12 e 13, compatível com derivados Ubuntu/Mint.

## Uso

1. Clone o repositório
2. Dê permissão de execução: `chmod +x *.sh`
3. Execute o script principal: `sudo ./main.sh`
4. Execute scripts opcionais conforme necessário
5. Reinicie o sistema para aplicar todas as configurações
