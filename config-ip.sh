#!/bin/sh
# ============================================================
# Script universal ultra-automático para configurar VPS
# Inclui: IP estático, DNS e hostname
# Compatível com: Alpine, Debian, Ubuntu, Fedora, Arch
# ============================================================

set -e

echo "===== Configuração Automática Ultra (IP + DNS + Hostname) ====="

# ------------------------------
# Detectar distribuição
# ------------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição."
    exit 1
fi
echo "Distribuição detectada: $DISTRO"

# ------------------------------
# Detectar interface ativa
# ------------------------------
INTERFACE=$(ip route | grep '^default' | awk '{print $5}')
if [ -z "$INTERFACE" ]; then
    echo "Não foi possível detectar a interface de rede automaticamente."
    exit 1
fi
echo "Interface detectada: $INTERFACE"

# ------------------------------
# Detectar gateway e CIDR
# ------------------------------
GATEWAY=$(ip route | grep '^default' | awk '{print $3}')
CIDR=$(ip addr show "$INTERFACE" | grep 'inet ' | awk '{print $2}' | head -n1)
NETMASK_CIDR=$(echo "$CIDR" | cut -d'/' -f2)

# Função para converter CIDR → máscara
mask2netmask() {
    local c=$1
    local b=""
    for i in 1 2 3 4; do
        if [ "$c" -ge 8 ]; then
            b="${b}255"
            c=$((c-8))
        else
            val=$((256 - 2**(8-c)))
            b="${b}${val}"
            c=0
        fi
        [ "$i" -lt 4 ] && b="${b}."
    done
    echo "$b"
}

NETMASK=$(mask2netmask "$NETMASK_CIDR")
echo "Máscara detectada: $NETMASK"

# ------------------------------
# Detectar IP público
# ------------------------------
IP=$(curl -s ifconfig.me)
echo "IP público detectado: $IP"

# ------------------------------
# Definir DNS e hostname padrão
# ------------------------------
DNS="1.1.1.1,8.8.8.8"
HOSTNAME="vps-$(date +%s | sha256sum | cut -c1-6)"  # Hostname único

echo "DNS definido: $DNS"
echo "Hostname definido: $HOSTNAME"

# ------------------------------
# Aplicar configuração
# ------------------------------
echo "Aplicando configuração no $DISTRO..."

case "$DISTRO" in
    alpine)
        cp /etc/network/interfaces /etc/network/interfaces.bak 2>/dev/null || true
        cat > /etc/network/interfaces <<EOL
auto $INTERFACE
iface $INTERFACE inet static
    address $IP
    netmask $NETMASK
    gateway $GATEWAY
EOL
        echo "nameserver $(echo $DNS | cut -d',' -f1)" > /etc/resolv.conf
        rc-service networking restart || (ifdown "$INTERFACE" && ifup "$INTERFACE")
        ;;
        
    debian|ubuntu)
        mkdir -p /etc/netplan
        cat > /etc/netplan/01-static.yaml <<EOL
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses: [$IP/$NETMASK_CIDR]
      gateway4: $GATEWAY
      nameservers:
        addresses: [$(echo $DNS | sed 's/,/, /g')]
EOL
        netplan apply
        ;;
        
    fedora)
        nmcli con mod "$INTERFACE" ipv4.addresses "$IP/$NETMASK_CIDR"
        nmcli con mod "$INTERFACE" ipv4.gateway "$GATEWAY"
        nmcli con mod "$INTERFACE" ipv4.dns "$(echo $DNS | sed 's/,/ /g')"
        nmcli con mod "$INTERFACE" ipv4.method manual
        nmcli con up "$INTERFACE"
        ;;
        
    arch)
        mkdir -p /etc/systemd/network
        cat > /etc/systemd/network/20-static.network <<EOL
[Match]
Name=$INTERFACE

[Network]
Address=$IP/$NETMASK_CIDR
Gateway=$GATEWAY
DNS=$(echo $DNS | sed 's/,/ /g')
EOL
        systemctl restart systemd-networkd
        ;;
        
    *)
        echo "Distribuição $DISTRO ainda não suportada automaticamente."
        exit 1
        ;;
esac

# ------------------------------
# Configurar hostname
# ------------------------------
echo "$HOSTNAME" > /etc/hostname
hostnamectl set-hostname "$HOSTNAME"

# ------------------------------
# Final
# ------------------------------
echo
echo "✅ Configuração ultra-automática concluída!"
echo "IP: $IP"
echo "Gateway: $GATEWAY"
echo "Máscara: $NETMASK"
echo "DNS: $DNS"
echo "Hostname: $HOSTNAME"
echo
ip addr show "$INTERFACE"
