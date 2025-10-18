#!/bin/sh

# Script ultra-automático para configurar IP público no Alpine Linux

echo "===== Configuração Ultra-Automática de IP Público ====="

# Detectar interface ativa
INTERFACE=$(ip route | grep '^default' | awk '{print $5}')
if [ -z "$INTERFACE" ]; then
    echo "Não foi possível detectar a interface de rede automaticamente."
    exit 1
fi
echo "Interface detectada: $INTERFACE"

# Detectar gateway padrão
GATEWAY=$(ip route | grep '^default' | awk '{print $3}')
echo "Gateway detectado: $GATEWAY"

# Detectar máscara padrão (usando CIDR da interface)
CIDR=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | head -n1)
NETMASK_CIDR=$(echo $CIDR | cut -d'/' -f2)

# Converter CIDR para máscara tradicional
mask2netmask() {
    c=$1
    b=""
    for i in 1 2 3 4; do
        if [ $c -ge 8 ]; then
            b="$b255"
            c=$((c-8))
        else
            val=$((256 - 2**(8-c)))
            b="$b$val"
            c=0
        fi
        [ $i -lt 4 ] && b="$b."
    done
    echo $b
}
NETMASK=$(mask2netmask $NETMASK_CIDR)
echo "Máscara detectada: $NETMASK"

# Detectar IP público atual
CURRENT_PUBLIC_IP=$(curl -s ifconfig.me)
echo "IP público atual detectado: $CURRENT_PUBLIC_IP"

# Perguntar se quer usar o IP atual ou digitar outro
read -p "Deseja usar o IP detectado ($CURRENT_PUBLIC_IP)? [S/n]: " USAR_ATUAL
USAR_ATUAL=${USAR_ATUAL:-S}

if [ "$USAR_ATUAL" = "S" ] || [ "$USAR_ATUAL" = "s" ]; then
    IP=$CURRENT_PUBLIC_IP
else
    read -p "Digite o IP público que deseja configurar: " IP
fi

# Backup do arquivo original
if [ -f /etc/network/interfaces ]; then
    cp /etc/network/interfaces /etc/network/interfaces.bak
    echo "Backup do /etc/network/interfaces criado em /etc/network/interfaces.bak"
fi

# Criar configuração estática
cat > /etc/network/interfaces <<EOL
auto $INTERFACE
iface $INTERFACE inet static
    address $IP
    netmask $NETMASK
    gateway $GATEWAY
EOL

echo "Configuração aplicada ao /etc/network/interfaces."

# Reiniciar a interface
echo "Reiniciando a interface $INTERFACE..."
ifdown $INTERFACE 2>/dev/null
ifup $INTERFACE

echo "IP estático configurado com sucesso!"
ip addr show $INTERFACE
