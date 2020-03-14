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
# $15 Nombre del bucket

cd /tmp
echo bucket:
echo ${15}
echo command START
aws s3 ls s3://${15}/guarani.tar.gz
echo command STOP

aws s3 ls s3://${15}/guarani.tar.gz > install_s_n.txt
if [ -s "install_s_n.txt" ]
then
  # El archivo existe ... lo bajo y lo instalo
  sudo aws s3 cp s3://${15}/guarani.tar.gz .
  sudo sh -c 'gunzip guarani.tar.gz'
  sudo sh -c 'tar xvf guarani.tar -C /'
else
  # El archivo no existe ... hago una instalacion desde cero.
  ./siu_install_run_once.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15}
fi
