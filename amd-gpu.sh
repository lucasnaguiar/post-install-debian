#!/bin/bash

# Script para configurar a placa de vídeo AMD RX 370 no Fedora com Wayland

if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado como root. Use: sudo ./amd-gpu.sh" >&2
  exit 1
fi

# 1. Firmware da GPU (necessário para o driver amdgpu reconhecer o hardware)
echo ">>> Instalando firmware AMD..."
dnf install -y linux-firmware

# 2. Drivers Mesa (OpenGL, Vulkan e aceleração de vídeo)
echo ">>> Instalando drivers Mesa..."
dnf install -y \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    mesa-libGL \
    mesa-libEGL \
    mesa-vdpau-drivers \
    libva-mesa-driver \
    vulkan-loader

# 3. Driver Xorg AMDGPU (usado como fallback e por algumas apps Wayland via XWayland)
echo ">>> Instalando driver Xorg AMDGPU..."
dnf install -y xorg-x11-drv-amdgpu

# 4. Ferramentas de diagnóstico
echo ">>> Instalando ferramentas de diagnóstico..."
dnf install -y \
    vulkan-tools \
    libva-utils \
    radeontop

echo ""
echo ">>> Configuração da GPU AMD concluída!"
echo ""
echo "----------------------------------------------------------------"
echo "  AÇÃO NECESSÁRIA:  "
echo "----------------------------------------------------------------"
echo "Reinicie o computador para que os drivers tenham efeito completo."
echo "----------------------------------------------------------------"

exit 0
