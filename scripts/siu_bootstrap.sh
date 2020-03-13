#!/bin/bash

sudo apt-get -y update
sudo apt-get install -y apache2

sudo a2enmod rewrite
sudo a2enmod setenvif
systemctl restart apache2

sudo apt update
sudo apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https
wget https://packages.sury.org/php/apt.gpg
sudo apt-key add apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.list
sudo apt update

sudo apt install -y php7.1 php7.1-cli php7.1-common
sudo apt-get install -y php7.1-cli php7.1-pgsql php7.1-gd php7.1-curl php7.1-mcrypt php-apcu php7.1-mbstring php7.1-xml php7.1-zip
sudo apt-get install -y php-memcached
sudo apt-get install -y libapache2-mod-php7.1

sudo apt-get install -y php7.1-dev php-pear postgresql-server-dev-9.6 build-essential

sudo sh -c 'echo ";Mínimos" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "output_buffering = On" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo ";Recomendados" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "memory_limit = 256M" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "upload_max_filesize = 8M" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "post_max_size = 8M" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "date.timezone = America/Argentina/Buenos_Aires" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "default_charset = \"ISO-8859-1\"" >> /etc/php/7.1/cli/php.ini'
sudo sh -c 'echo "mbstring.internal_encoding = \"ISO-8859-1\"" >> /etc/php/7.1/cli/php.ini'

sudo sh -c 'echo ";Mínimos" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "output_buffering = On" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo ";Recomendados" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "memory_limit = 256M" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "upload_max_filesize = 8M" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "post_max_size = 8M" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "date.timezone = America/Argentina/Buenos_Aires" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "default_charset = \"ISO-8859-1\"" >> /etc/php/7.1/apache2/php.ini'
sudo sh -c 'echo "mbstring.internal_encoding = \"ISO-8859-1\"" >> /etc/php/7.1/apache2/php.ini'

sudo service apache2 restart

sudo apt-get install -y subversion
sudo apt-get install -y git
sudo apt-get install -y zip
sudo apt-get install -y unzip
# composer
wget https://getcomposer.org/composer-stable.phar
sudo mv composer-stable.phar /usr/local/bin/composer
chmod a+x /usr/local/bin/composer

#bower
sudo apt-get -y update
sudo apt-get -y install nodejs
sudo apt-get -y install nodejs-legacy
#sudo apt-get -y install npm
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g bower

sudo apt-get install -y graphviz
sudo apt-get install -y default-jdk

# siu
sudo mkdir /usr/local/proyectos
sudo mkdir /usr/local/proyectos/guarani
