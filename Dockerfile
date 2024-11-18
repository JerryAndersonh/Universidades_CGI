FROM bitnami/minideb

ENV DEBIAN_FRONTEND="noninteractive"

# Instalar paquetes necesarios y configurar el locale
RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl libtext-csv-perl locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Generar y establecer el locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Habilitar módulo cgid de Apache
RUN a2enmod cgid

# Crear directorios necesarios
RUN mkdir -p /usr/lib/cgi-bin /var/www/html

# Copiar los archivos CGI y HTML al contenedor
COPY ./cgi-bin/ /usr/lib/cgi-bin/
COPY ./html/ /var/www/html/

# Asegurarse de que data.csv esté copiado en el contenedor
COPY ./cgi-bin/data.csv /usr/lib/cgi-bin/data.csv

# Dar permisos a los archivos
RUN chmod +x /usr/lib/cgi-bin/*.pl && \
    chmod -R 755 /usr/lib/cgi-bin/* && \
    chmod 755 /var/www/html/*.html && \
    chmod 755 /var/www/html/style.css

RUN chmod -R 755 /var/www/html

# Exponer el puerto 80
EXPOSE 80

# Ejecutar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
