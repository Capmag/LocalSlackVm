Proyecto Final: Simulación de Infraestructura Cloud con Terraform y LocalStack (AWS)
`
Andres Raul Renteria Gastelum 
20490733

Este documento explica cómo iniciar nuevamente el entorno, verificar LocalStack, consultar los recursos ya creados y demostrar que el proyecto funciona correctamente.

1. Requisitos previos

Asegúrate de tener instalados en la VM:

Docker + Docker Compose Plugin
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

AWS CLI
sudo apt-get install -y awscli

Terraform

2. Encender LocalStack

Ir al directorio del proyecto:

cd ~/proyecto-final


Levantar LocalStack:

docker compose up -d


Verificar que el contenedor está corriendo:

docker ps


Validar salud del servicio:

curl http://localhost:4566/health


3. Verificar los recursos en AWS CLI (LocalStack)
Listar buckets S3:
aws --endpoint-url=http://localhost:4566 s3 ls

Ver contenido del bucket del proyecto:
aws --endpoint-url=http://localhost:4566 s3 ls s3://proyecto-final-alumno-20490733

Imprimir el archivo index.html almacenado en S3:
aws --endpoint-url=http://localhost:4566 s3 cp \
s3://proyecto-final-alumno-20490733/index.html -

4. Verificar DynamoDB

Listar tablas:

aws --endpoint-url=http://localhost:4566 dynamodb list-tables


Describir la tabla Usuarios:

aws --endpoint-url=http://localhost:4566 dynamodb describe-table \
--table-name Usuarios


Resultado esperado (resumen):

{
  "Table": {
    "TableName": "Usuarios",
    "KeySchema": [{ "AttributeName": "UserID", "KeyType": "HASH" }],
    "TableStatus": "ACTIVE"
  }
}

5. Volver a sincronizar Terraform con el estado real

Si LocalStack se reinició, siempre es buena idea refrescar el estado:

terraform refresh


Mostrar outputs del proyecto:

terraform output

ejemplo:
s3_bucket_name = "proyecto-final-alumno-20490733"
dynamodb_table_name = "Usuarios"
vpc_id = "vpc-79e60909e7b1b04c9"


7. Apagar LocalStack 
docker compose down
