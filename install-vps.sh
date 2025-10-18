#!/bin/sh
# =========================================================
# Script COMPLETO de configuração de VPS Alpine
# Instala linguagens, servidores, bancos, Docker, VPNs, Vim, C/C++
# Cria usuário com sudo
# =========================================================

echo "=========================================="
echo "Bem-vindo ao configurador de VPS Alpine"
echo "=========================================="

# ===========================
# Criar usuário com sudo
# ===========================
read -p "Digite o nome do usuário que deseja criar: " NEWUSER
adduser -D $NEWUSER
echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "Usuário $NEWUSER criado com privilégios sudo."

# ===========================
# Atualiza repositórios
# ===========================
apk update && apk upgrade

# ===========================
# Ferramentas básicas
# ===========================
apk add --no-cache bash curl wget git htop tmux vim unzip zip sudo shadow build-base cmake make g++

# ===========================
# Instala linguagens
# ===========================
# Python
apk add --no-cache python3 py3-pip python3-dev
pip3 install --upgrade pip setuptools wheel virtualenv

# Node.js
apk add --no-cache nodejs npm

# Java (OpenJDK 17)
apk add --no-cache openjdk17

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# PHP
apk add --no-cache php php-cli php-mbstring php-curl php-json php-openssl php-phar php-dev

# Go
apk add --no-cache go

# C e C++ já inclusos em build-base e g++
# build-base inclui gcc, g++, make e outras ferramentas de compilação

# ===========================
# Instala servidores
# ===========================
apk add --no-cache nginx apache2 apache2-utils
rc-update add nginx boot
rc-update add apache2 boot

# ===========================
# Instala bancos de dados
# ===========================
apk add --no-cache mariadb mariadb-client mariadb-dev redis
rc-update add mariadb boot
rc-update add redis boot

# ===========================
# Instala Docker
# ===========================
apk add --no-cache docker docker-cli docker-compose
rc-update add docker boot
service docker start

# ===========================
# Instala Hamachi
# ===========================
apk add --no-cache openvpn lsb-core
wget https://www.vpn.net/installers/logmein-hamachi-2.1.0.203-alpine.tgz -O /tmp/hamachi.tgz
tar -xzf /tmp/hamachi.tgz -C /opt/
chmod +x /opt/logmein-hamachi-2.1.0.203/hamachi
ln -s /opt/logmein-hamachi-2.1.0.203/hamachi /usr/local/bin/hamachi

# ===========================
# Instala ZeroTier
# ===========================
wget https://download.zerotier.com/dist/Alpine/zerotier-one_latest_amd64.apk -O /tmp/zerotier.apk
apk add --allow-untrusted /tmp/zerotier.apk
rc-update add zerotier-one boot
service zerotier-one start

# ===========================
# Mensagem final
# ===========================
echo "=========================================="
echo "VPS totalmente configurada!"
echo "Usuário criado: $NEWUSER (sudo)"
echo "Linguagens: Python, Node.js, Java, C/C++, Rust, PHP, Go"
echo "Servidores: Nginx, Apache"
echo "Bancos de dados: MariaDB, Redis"
echo "Docker instalado"
echo "VPNs: Hamachi, ZeroTier"
echo "Ferramentas básicas instaladas (Vim incluso)"
echo "=========================================="
