Proyecto Final – LocalStack + Terraform (AWS simulado)
Autor: Raul Renteria
Matrícula: 20490733
Proyecto: proyecto_final_raulrenteria-20490733

Descripción
Este proyecto construye una infraestructura básica en AWS simulada utilizando dos herramientas fundamentales:

LocalStack: una plataforma que emula localmente la mayoría de los servicios de AWS en un contenedor Docker, evitando el uso de una cuenta real y posibles costos.

Terraform: la herramienta de Infraestructura como Código (IaC) utilizada para definir y desplegar la infraestructura simulada de AWS.

La arquitectura resultante incluye tres capas lógicas:

Red y Seguridad (networking): VPC, subred, Internet Gateway e identidades de seguridad que permiten tráfico HTTP.

Almacenamiento: un bucket S3 llamado proyecto-final-alumno-20490733 con un archivo estático index.html cargado a través de Terraform.

Base de Datos: una tabla DynamoDB llamada Usuarios con una clave de partición (UserID).

Todo el entorno se ejecuta localmente en una máquina virtual (por ejemplo en Google Cloud) sin requerir acceso a AWS real, lo que facilita el aprendizaje y las pruebas de IaC.

Requisitos
En la máquina donde se ejecuta este proyecto necesitas instalar:

Docker y el plugin docker compose.

Terraform.

AWS CLI para la verificación de recursos en LocalStack.

Nota: las instrucciones a continuación están pensadas para distribuciones basadas en Debian/Ubuntu. Ajusta los comandos si utilizas otra distribución.

Instalación resumida (Debian/Ubuntu)
bash
Copiar código
# 1. Instalar Docker y el plugin docker compose
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Agregar la llave GPG de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Agregar el repositorio estable de Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Habilitar y arrancar Docker
sudo systemctl enable --now docker

# Añadir tu usuario al grupo docker (luego cierra sesión y vuelve a entrar)
sudo usermod -aG docker "$USER"

# 2. Instalar Terraform (repositorios de HashiCorp)
sudo apt-get update
sudo apt-get install -y wget gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get install -y terraform

# 3. Instalar AWS CLI
sudo apt-get update
sudo apt-get install -y awscli
Reinicia la sesión o ejecuta newgrp docker para que los permisos de Docker se apliquen.

Estructura del repositorio
graphql
Copiar código
proyecto-final/
├── docker-compose.yml   # Levanta LocalStack en un contenedor Docker
├── main.tf              # Define la infraestructura (red, S3, DynamoDB, EC2 simulado)
├── variables.tf         # Variables de Terraform (región, endpoint, nombres)
├── outputs.tf           # Outputs de IDs y ARNs de los recursos
├── index.html           # Archivo HTML que se sube al bucket S3
└── README.md            # Este documento
1. Levantar LocalStack
Desde el directorio raíz del proyecto (proyecto-final/), ejecuta:

bash
Copiar código
docker compose up -d
Esto descargará y levantará la imagen localstack/localstack en segundo plano. El puerto 4566 quedará expuesto en tu VM.

Para verificar que el contenedor está corriendo correctamente:

bash
Copiar código
docker ps
curl http://localhost:4566/health
El comando docker ps mostrará el contenedor y curl devolverá un JSON con el estado de los servicios simulados.

2. Inicializar y aplicar Terraform
Asegúrate de que estás ubicado en el directorio del proyecto. Ejecuta los siguientes comandos:

bash
Copiar código
terraform init
terraform plan
terraform apply
terraform init descarga los plugins necesarios (el provider aws) y prepara el directorio.

terraform plan muestra un resumen de las acciones que realizará Terraform para crear la infraestructura.

terraform apply aplica el plan. Cuando se solicite confirmación, escribe yes y presiona Enter.

Si todo va bien, al final verás algo como:

yaml
Copiar código
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
Los outputs definidos en outputs.tf se mostrarán con los IDs y ARNs de cada recurso (VPC, Subnet, Bucket S3, Tabla DynamoDB, etc.).

Nota sobre EC2: LocalStack Community Edition no soporta completamente EC2. En este proyecto el recurso aws_instance se declara con count = 0, lo que significa que no se crea realmente ninguna instancia, pero se mantiene la definición en el código para cumplir con los objetivos de aprendizaje.

3. Configurar AWS CLI para LocalStack
Antes de utilizar aws cli para interactuar con LocalStack, configúralo con credenciales falsas y una región por defecto. Ejecuta:

bash
Copiar código
aws configure
Introduce los siguientes valores cuando se soliciten:

AWS Access Key ID: test

AWS Secret Access Key: test

Default region name: us-east-1

Default output format: json

Estas credenciales son solo de relleno para que el CLI funcione. La comunicación se realizará con el endpoint local de LocalStack.

4. Verificar los recursos creados en LocalStack
Los comandos a continuación utilizan la opción --endpoint-url para indicar a AWS CLI que hable con LocalStack en lugar de AWS real.

4.1. Verificación de S3
Para listar todos los buckets simulados:

bash
Copiar código
aws --endpoint-url=http://localhost:4566 s3 ls
Deberías ver proyecto-final-alumno-20490733 en la lista. Para listar el contenido de ese bucket:

bash
Copiar código
aws --endpoint-url=http://localhost:4566 s3 ls s3://proyecto-final-alumno-20490733
Aparecerá el archivo index.html. Si quieres ver su contenido:

bash
Copiar código
aws --endpoint-url=http://localhost:4566 s3 cp s3://proyecto-final-alumno-20490733/index.html -
4.2. Verificación de DynamoDB
Para listar las tablas de DynamoDB en LocalStack:

bash
Copiar código
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
La salida debería incluir la tabla Usuarios.

5. Destruir la infraestructura (opcional)
Si deseas eliminar los recursos simulados y dejar el entorno limpio, ejecuta:

bash
Copiar código
terraform destroy
Escribe yes cuando solicite confirmación. Esto borrará la infraestructura de LocalStack.

Para detener y eliminar el contenedor de LocalStack:

bash
Copiar código
docker compose down
6. Evidencias recomendadas para la entrega
Para respaldar tu trabajo, guarda capturas de pantalla o copias de las salidas de los siguientes comandos:

docker ps mostrando el contenedor LocalStack corriendo.

terraform apply al finalizar con Apply complete!.

terraform output con los IDs y ARNs de los recursos.

aws --endpoint-url=http://localhost:4566 s3 ls mostrando el bucket.

aws --endpoint-url=http://localhost:4566 s3 ls s3://proyecto-final-alumno-20490733 mostrando index.html.

aws --endpoint-url=http://localhost:4566 dynamodb list-tables mostrando la tabla Usuarios.

Estas evidencias demuestran que tu entorno local funciona y que se han cumplido todos los requisitos del proyecto.
