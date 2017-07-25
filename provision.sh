#!/bin/bash

DB_ROOT_PASSWORD=$1
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
TEST_DB_NAME=$5
DJANGO_SETTINGS=$6
DJANGO_REQUIREMENTS=$7


if [ ! -f /usr/local/lib/python2.7.13/bin/python2.7 ]; then

    sudo apt-get -y update

    sudo chown $USER:$USER -R  /usr/local/lib

    # Install prerequisites for Python before installing it.
    dpkg -s build-essential &>/dev/null || {
      sudo apt-get install -y build-essential
    }

    dpkg -s checkinstall &>/dev/null || {
      sudo apt-get install -y checkinstall
    }

    dpkg -s libreadline-gplv2-dev &>/dev/null || {
      sudo apt-get install -y libreadline-gplv2-dev
    }

    dpkg -s libncursesw5-dev &>/dev/null || {
      sudo apt-get install -y libncursesw5-dev
    }

    dpkg -s libssl-dev &>/dev/null || {
      sudo apt-get install -y libssl-dev
    }

    dpkg -s libsqlite3-dev &>/dev/null || {
      sudo apt-get install -y libsqlite3-dev
    }

    dpkg -s tk-dev &>/dev/null || {
      sudo apt-get install -y tk-dev
    }

    dpkg -s libgdbm-dev &>/dev/null || {
      sudo apt-get install -y libgdbm-dev
    }

    dpkg -s libc6-dev &>/dev/null || {
      sudo apt-get install -y libc6-dev
    }

    dpkg -s libbz2-dev &>/dev/null || {
      sudo apt-get install -y libbz2-dev
    }

    # Download and extract Python 2.7.13
    wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
    tar xzf Python-2.7.13.tgz

    # Compile Python Source
    cd Python-2.7.13
    ./configure --prefix /usr/local/lib/python2.7.13
    make
    make altinstall

fi


#Updating and instaling dependencies
sudo apt-get -y update
sudo apt-get -y upgrade

# fix possible locale issues
echo "Setting locale..."
echo "# Locale settings
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8">>~/.bashrc

sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
source ~/.bashrc

# update PATH
echo "PATH=$PATH:$HOME/.local/bin/">>~/.bashrc
source ~/.bashrc

# set DJANGO_SETTINGS_MODULE environment variable
echo "export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS">>~/.bashrc
source ~/.bashrc

# update PYTHONPATH
echo "export PYTHONPATH=$PYTHONPATH:/vagrant">>~/.bashrc
source ~/.bashrc

# Python dev packages
dpkg -s build-essential &>/dev/null || {
	sudo apt-get install -y build-essential
}


dpkg -s python-dev &>/dev/null || {
	sudo apt-get install -y python-dev
}

dpkg -s python-setuptools &>/dev/null || {
	sudo apt-get install -y  python-setuptools
}

# Dependencies for image processing with Pillow (drop-in replacement for PIL)
# supporting: jpeg, tiff, png, freetype, littlecms
dpkg -s libjpeg-dev &>/dev/null || {
	sudo apt-get install -y libjpeg-dev
}

dpkg -s libtiff5-dev &>/dev/null || {
	sudo apt-get install -y libtiff5-dev
}

dpkg -s zlib1g-dev &>/dev/null || {
	sudo apt-get install -y zlib1g-dev
}

dpkg -s libfreetype6-dev &>/dev/null || {
	sudo apt-get install -y libfreetype6-dev
}

dpkg -s liblcms2-dev &>/dev/null || {
	sudo apt-get install -y liblcms2-dev
}

# Git (we'd rather avoid people keeping credentials for git commits in the repo,
# but sometimes we need it for pip requirements that aren't in PyPI)
dpkg -s git &>/dev/null || {
	sudo apt-get install -y git
}

# MySQL

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWORD"

sudo apt-get -y install mysql-server

# helps MySQL cooperate with Python
dpkg -s libmysqlclient-dev &>/dev/null || {
    sudo apt-get install libmysqlclient-dev
}

#MySQL configuration
sudo mysql_install_db

if [ ! -f /var/log/databasesetup ];
then
    echo "CREATE DATABASE $DB_NAME" | mysql -uroot -p$DB_ROOT_PASSWORD
    echo "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'" | mysql -uroot -p$DB_ROOT_PASSWORD
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost'" | mysql -uroot -p$DB_ROOT_PASSWORD
    echo "GRANT ALL PRIVILEGES ON $TEST_DB_NAME.* TO '$DB_USER'@'localhost'" | mysql -uroot -p$DB_ROOT_PASSWORD
    echo "flush privileges" | mysql -uroot -p$DB_ROOT_PASSWORD

    sudo touch /var/log/databasesetup
fi

# pip install
if ! command -v pip; then
	curl -O https://bootstrap.pypa.io/get-pip.py
	/usr/local/lib/python2.7.13/bin/python2.7 get-pip.py --user
fi

# virtualenv install
if [ ! -f /home/vagrant/.local/bin/virtualenv ]; then
    /usr/local/lib/python2.7.13/bin/python2.7 -m pip install virtualenv --user
fi


cd /vagrant
/usr/local/lib/python2.7.13/bin/python2.7 -m virtualenv venv
source venv/bin/activate
pip install -r $DJANGO_REQUIREMENTS

