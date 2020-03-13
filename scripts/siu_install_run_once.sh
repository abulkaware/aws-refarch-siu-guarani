#!/bin/bash
# $1 SVN Codigo de Universidad (dos digitos)
# $2 SVN Version
# $3 SVN Username
# $4 SVN Password
# $5 SIU Numero de Desarrollador
# $6 SIU Nombre de Instancia postgres
# $7 SIU URL/IP Endpoint Postgres
# $8 SIU Puerto Endpoint Postgres
# $9 SIU Username Postgres
# $10 SIU Nombre de Base de Datos Postgres
# $11 SIU Password Postgres
# $12 TOBA Alias
# $13 TOBA Schema de la base de datos
# $14 TOBA Clave toba
# $15 Bucket S3

SVNCMD="svn --non-interactive checkout https://colab.siu.edu.ar/svn/guarani3/nodos/$1/gestion/trunk/$2 /usr/local/proyectos/guarani  --username $3 --password $4"
sudo $SVNCMD

cd /usr/local/proyectos/guarani
sudo composer install --prefer-dist --no-dev --optimize-autoloader

export TOBA_INSTANCIA=desarrollo
export TOBA_INSTALACION_DIR=/usr/local/proyectos/guarani/instalacion
cd /usr/local/proyectos/guarani/bin

# Guardo las passwords en un archivo (como pide toba)
echo -n ${11} > /tmp/tmp1.txt
echo -n ${14} > /tmp/tmp2.txt

# Armo comando de instalacion
TOBAINSTCMD="./toba instalacion instalar -d $5 -n $6 -t 0 -h $7  -p $8 -u $9 -b ${10} -c /tmp/tmp1.txt --no-interactive --alias-nucleo ${12} --schema-toba ${13} -k /tmp/tmp2.txt"
echo $TOBAINSTCMD

# Ejecuto comando de instalacion . pero cuando llega al prompt del nucleo de toba lo completa con el parametro y apreta ENTER. (BUG del instalador de Toba)
yes ${12} | sudo $TOBAINSTCMD

# Comando correcto para cuando corrijan bug
#sudo $TOBAINSTCMD

# Borro los archivos con la password
rm /tmp/tmp1.txt
rm /tmp/tmp2.txt

sudo ln -s /usr/local/proyectos/guarani/instalacion/toba.conf /etc/apache2/sites-enabled/toba_3_0.conf

sudo sh -c 'echo "[xslfo]" > /usr/local/proyectos/guarani/instalacion/instalacion.ini'
sudo sh -c 'echo "fop=/usr/local/proyectos/guarani/php/3ros/fop/fop" > /usr/local/proyectos/guarani/instalacion/instalacion.ini'

sudo chown -R www-data:www-data /usr/local/proyectos/guarani/www
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/temp
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/instalacion
sudo mkdir /usr/local/proyectos/guarani/metadatos_compilados
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/metadatos_compilados
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/www
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/vendor/siu-toba/framework/temp

sudo ln -s /usr/local/proyectos/guarani/instalacion/toba.conf /etc/apache2/sites-available/gestion.conf
sudo a2ensite gestion.conf
sudo service apache2 reload

cd /usr/local/proyectos/guarani
sudo sh -c 'echo "menu = 0" > menu.ini'

cd /usr/local/proyectos/guarani/bin
# OJO pregunta agregar alias apache
yes s | sudo ./guarani cargar -d /usr/local/proyectos/guarani

sudo service apache2 restart

# Usuario 
sudo sh -c 'echo "[guarani]" >> /usr/local/proyectos/guarani/instalacion/i__desarrollo/p__guarani/rest/servidor_usuarios.ini'
sudo sh -c 'echo "password = $14" >> /usr/local/proyectos/guarani/instalacion/i__desarrollo/p__guarani/rest/servidor_usuarios.ini'

cd /usr/local/proyectos/guarani/bin
yes s | sudo ./guarani instalar

cd /usr/local/proyectos/guarani/bin
yes s | sudo ./guarani crear_auditoria -f guarani

java -jar /usr/local/proyectos/guarani/vendor/siu-toba/jasper/JavaBridge/WEB-INF/lib/JavaBridge.jar SERVLET_LOCAL:8081 &

sudo sh -c 'cat /usr/local/proyectos/guarani/instalacion/instalacion.ini | grep -v es_produccion > /usr/local/proyectos/guarani/instalacion/instalacion.ini.tmp'
sudo sh -c 'echo "es_produccion = 1" >> /usr/local/proyectos/guarani/instalacion/instalacion.ini.tmp'
sudo mv /usr/local/proyectos/guarani/instalacion/instalacion.ini.tmp /usr/local/proyectos/guarani/instalacion/instalacion.ini

sudo sh -c 'echo "usar_perfiles_propios = 1" >> /usr/local/proyectos/guarani/instalacion/i__desarrollo/instancia.ini'

cd /usr/local/proyectos/guarani/bin
yes s | sudo ./guarani compilar
sudo chown -R www-data:www-data /usr/local/proyectos/guarani/metadatos_compilados

# Descomento
cd /usr/local/proyectos/guarani/www
sudo sh -c 'sed -i "/apex_pa_metadatos_compilados/s/^#//g" aplicacion.php'

# ojo las contestaciones
cd /usr/local/proyectos/guarani/bin
yes s | sudo ./toba proyecto eliminar -p toba_editor -i desarrollo
yes s | sudo ./toba proyecto eliminar -p toba_referencia -i desarrollo
yes s | sudo ./toba proyecto despublicar -p toba_editor -i desarrollo
yes s | sudo ./toba proyecto despublicar -p toba_referencia -i desarrollo

sudo chown -R www-data:www-data /usr/local/proyectos/guarani/instalacion

sudo service apache2 restart
 
# Hago un tar y lo subo a S3
cd
sudo sh -c 'tar cvf guarani.tar /usr/local/proyectos/guarani/'
sudo sh -c 'gzip guarani.tar'
aws s3 cp guarani.tar.gz s3://${15}
