
---

# Configurador Completo de VPS Universal

Este script automatiza a configuração de uma VPS, preparando-a para desenvolvimento full-stack, servidores e serviços essenciais, com suporte para **Debian, Ubuntu, Fedora, Arch, Void e Alpine**.

---

## Funcionalidades

### 1. Usuário

* Pergunta se deseja criar um usuário durante a execução.
* Concede privilégios **sudo** ao usuário criado.

### 2. Linguagens Instaladas

* **Python 3** (com pip, virtualenv, setuptools, wheel)
* **Node.js** e **npm**
* **Java (OpenJDK 17)**
* **C e C++** (gcc, g++, make, build-essential/base-devel/build-base)
* **Rust** (via rustup)
* **PHP** (php-cli, php-mbstring, php-curl, php-json, php-openssl, php-phar, php-dev)
* **Go**

### 3. Servidores

* **Nginx**
* **Apache**

### 4. Bancos de Dados

* **MariaDB**
* **Redis**

### 5. Contêineres

* **Docker**
* **Docker Compose**

### 6. VPNs

* **Hamachi** (Alpine automático, manual em outras distros)
* **ZeroTier** (Alpine automático, manual em outras distros)

### 7. Ferramentas Básicas

* **Bash, Curl, Wget, Git, Htop, Tmux, Vim, Unzip, Zip, Sudo**
* Ferramentas de compilação (**build-essential, cmake, make, g++ / build-base / base-devel**)

---

## Como usar

```bash
git clone https://github.com/aliendede1/Server-Alpine.git
chmod +x *.sh
./install-vps.sh
```

> O script detecta automaticamente sua distribuição e ajusta os comandos de instalação para Debian, Ubuntu, Fedora, Arch, Void ou Alpine.

---
