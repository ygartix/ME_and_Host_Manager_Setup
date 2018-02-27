#!/bin/bash

# run script with sudo!"

# prep stage: add user to sudoer
# sudo adduser administrator sudo

echo "----- Start install_Linux_main_engine script -----"
if [ -z "$1" ]; then
    echo "----- First parameter 'user name' should be supplied!!! -----"
    exit
fi

USER_NAME=$1
PASSWORD=$2

set -e

echo ----- Install pip2 dependencies -----
echo $PASSWORD | sudo -S apt-get -y install git python-pip python-suds python-pymssql python-prettytable python-enum
echo $PASSWORD | sudo -S pip install --upgrade pip
echo $PASSWORD | sudo -S pip install paramiko logger

DIR=rs_autolabs

if [ -d "$DIR" ]; then
    sudo rm -rf $DIR
fi

sudo mkdir -p $DIR
sudo chown -R $USER_NAME $DIR

# password required - consider faceless account (consider using lab_labtfs)
## "realto-i" check for lab-user
# faceless user: lab_autoinstaller
# password:      1a2B3c4D_ZAYBxc
git clone https://lab_autoinstaller:1a2B3c4D_ZAYBxc@git-ger-8.devtools.intel.com/gerrit/p/rs_autolabs.git

#User: auto_lab_installer@intel.com
#Pass: xzxvi00@

echo ----- Setting environment variable: PYTHONPATH -----
sudo chown -R $USER_NAME /etc/environment
EXPORT_LINE="PYTHONPATH='/home/$USER_NAME/rs_autolabs/"
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment
