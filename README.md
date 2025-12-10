# Proyecto Final – LocalStack + Terraform (AWS simulado)
Autor: Raul Renteria  
Matrícula: 20490733  
Proyecto: proyecto_final_raulrenteria-20490733

## Descripción

Este proyecto implementa una infraestructura básica de AWS de forma **simulada** utilizando:

- [LocalStack](https://localstack.cloud/) para emular los servicios de AWS en local.
- [Terraform](https://www.terraform.io/) para gestionar la infraestructura como código (IaC).

Se despliegan tres capas:

- **Red y Seguridad**: VPC, Subnet, Internet Gateway, Security Group.
- **Almacenamiento (S3)**: Bucket S3 `proyecto-final-alumno-20490733` con un archivo `index.html`.
- **Base de Datos (DynamoDB)**: Tabla `Usuarios` con `UserID` como Partition Key.

Todo corre dentro de una VM (por ejemplo, en Google Cloud), sin usar una cuenta real de AWS.

---

## Requisitos

En la máquina donde se ejecuta el proyecto se requiere:

- Docker y Docker Compose Plugin
- Terraform
- AWS CLI
- Acceso a internet para descargar imágenes y providers.

### Instalación (resumen en Debian/Ubuntu)

```bash
# Docker (repositorio oficial de Docker)
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# Terraform (HashiCorp repo)
sudo apt-get update
sudo apt-get install -y wget gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get install -y terraform

# AWS CLI
sudo apt-get update
sudo apt-get install -y awscli
