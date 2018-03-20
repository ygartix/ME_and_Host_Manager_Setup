#!/bin/bash

# run script with sudo!"

# prep stage: add user to sudoer
# sudo adduser administrator sudo

echo "----- Start install_Linux_host script -----"
if [ -z "$1" ]; then
    echo "----- First parameter 'user name' should be supplied!!! -----"
    exit
fi

USER_NAME=$1
PASSWORD=$2

set -e

echo $PASSWORD | sudo -S apt-get -y install git python-pip lsb-core

DIR=rs_autolabs

if [ -d "$DIR" ]; then
    sudo rm -rf $DIR
fi

sudo mkdir -p $DIR
sudo chown -R $USER_NAME $DIR

# password required - consider faceless account (consider using lab_labtfs)
## "realto-i" check for lab-user
# faceless user: lab_autoinstaller
#password:       1a2B3c4D_ZAYBxc
git clone https://rsautolabs:rsautolabs_intel@github.com/IntelRealSense/rs_autolabs.git

#User: auto_lab_installer@intel.com
#Pass: xzxvi00@

# setup environment variables
echo setup environment variables...

echo ----- Setting environment variable: TESTS_ROOT_DIR -----
sudo chown -R $USER_NAME /etc/environment
EXPORT_LINE="TESTS_ROOT_DIR=/home/$USER_NAME/rs_autolabs/tests_repo"
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment

echo ----- Creating temp_dir folder -----
TEMP_DIR="/home/"$USER_NAME"/temp_dir"
echo ----- TEMP_DIR=$TEMP_DIR
sudo mkdir -p $TEMP_DIR
sudo chown -R $USER_NAME $TEMP_DIR

echo ----- Setting environment variable: TEMP_DIR -----
EXPORT_LINE="TEMP_DIR="$TEMP_DIR
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment

echo ----- Setting environment variable: PYTHONPATH -----
EXPORT_LINE="PYTHONPATH=/home/$USER_NAME/rs_autolabs:."
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment

echo ----- Setting environment variable: REALSENSE_DRIVER -----
EXPORT_LINE="REALSENSE_DRIVER=LIBREALSENSE26"
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment

echo ----- Install pip2 dependencies -----
sudo pip install --upgrade pip
sudo apt-get -y install python-suds
sudo pip install bunch
sudo pip install py-cpuinfo
sudo pip install logger
sudo apt-get -y install python-enum
sudo pip install numpy
sudo apt-get -y install python-pyatspi
sudo pip install scipy
sudo pip install pyStopWatch
sudo apt-get -y install lsb-core


echo ----- Mount shared folder -----
function mount {
	# https://wiki.ubuntu.com/MountWindowsSharesPermanently
	sudo apt-get -y install cifs-utils

	local line=$1
	local dir=$2
	local config=$3

	sudo mkdir -p $dir

	sudo grep -qF "$line" "$config" || echo "$line" >> "$config"

	# Mount all entries listed in /etc/fstab.
	sudo mount -a
}

#readonly
MOUNT_TARGET="//rslabs-nas.iil.intel.com/VIDB  /media/windowsshare  cifs  username=valkyrie_boss,password=Nd?WvO46h3Ki:nT%5r03,domain=rslabs-nas,iocharset=utf8,sec=ntlm  0  0"
MOUNT_SOURCE="/media/windowsshare"
MOUNT_CONFIG_FILE="/etc/fstab"

mount "$MOUNT_TARGET" "$MOUNT_SOURCE" "$MOUNT_CONFIG_FILE"

echo ----- Installation process ended -----
