# Configurador Completo de VPS Alpine

Este script automatiza a configuração de uma VPS Alpine, preparando-a para desenvolvimento full-stack, servidores e serviços essenciais.  

---

## Funcionalidades

### 1. Usuário
- Cria um usuário definido pelo usuário durante a execução.
- Concede privilégios **sudo** ao usuário criado.

### 2. Linguagens Instaladas
- **Python 3** (com pip, virtualenv, setuptools, wheel)  
- **Node.js** e **npm**  
- **Java (OpenJDK 17)**  
- **C e C++** (gcc, g++, make, build-base)  
- **Rust** (via rustup)  
- **PHP** (php-cli, php-mbstring, php-curl, php-json, php-openssl, php-phar, php-dev)  
- **Go**

### 3. Servidores
- **Nginx**  
- **Apache**

### 4. Bancos de Dados
- **MariaDB**  
- **Redis**

### 5. Contêineres
- **Docker**  
- **Docker Compose**

### 6. VPNs
- **Hamachi**  
- **ZeroTier**

### 7. Ferramentas Básicas
- **Bash, Curl, Wget, Git, Htop, Tmux, Vim, Unzip, Zip, Sudo**  
- Ferramentas de compilação (**build-base, cmake, make, g++**)

---



```bash
wget <link_do_script.sh> -O vps_setup.sh
chmod +
