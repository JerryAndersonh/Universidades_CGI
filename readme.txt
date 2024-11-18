### Crear imagen y contenedor para el despliegue 

docker build -t image-grupo4 .

docker run -d -p 8084:80 --name contenedor-grupo4 image-grupo4