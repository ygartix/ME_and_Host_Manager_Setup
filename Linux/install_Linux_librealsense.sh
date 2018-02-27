#!/bin/bash
# Install librealsense on a given librealasense directory path
# Run command: sudo bash ~/Desktop/install_Linux_librealsense.sh
set -e
export NPROCS=`grep -c ^processor /proc/cpuinfo`

function install_librealsense {
    echo "Install librealsense and pyrealsense"

    USER_NAME=$1
    BRANCH_VERSION=$2

    echo "Change directory to /home/"$USER_NAME
    cd "/home/"$USER_NAME
    # e.g. v2.6.7
    #git clone --branch v2.6.7 https://github.intel.com/PercHW/librealsense.git
    git clone --branch $BRANCH_VERSION https://github.intel.com/PercHW/librealsense.git

    echo ----- Install cmake -----
    sudo apt-get -y install cmake

    echo "Change directory to: "${librealsense_directory}
    cd ${librealsense_directory}

    echo "Create 'build' folder"
    sudo mkdir -p build
    sudo chown -R $USER_NAME build

    echo "Change directory to 'build' folder"
    cd build

    echo "Install python python-dev"
    sudo apt-get -y install python python-dev

    echo "Execute cmake command..."
    cmake ../ -DCMAKE_BUILD_TYPE=release -DBUILD_EXAMPLES=true -DBUILD_PYTHON_BINDINGS=bool:true -DPYTHON_EXECUTABLE=/usr/bin/python2.7

    sudo make uninstall && make clean && make -j8 && sudo make install

    cd ..
    sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules && udevadm trigger
    echo "sudo modprobe uvcvideo"
    sudo modprobe uvcvideo

    echo "Install libssl-dev"
    sudo apt-get -y install libssl-dev

    echo "Should be done by the image!!! Configuring Intel Proxies for Kernel Patches"
    #sudo apt-get -y install git python socat
    #wget https://github.intel.com/raw/PercHW/scripts/master/intel_proxy_setup.py
    #sudo python intel_proxy_setup.py apply
    #cd ~/librealsense

    echo "Execute ./scripts/patch-realsense-ubuntu-xenial.sh"
    echo "This script disbaled since asking y/n questions..."
    # The update kernel script (see bellow)is not part of the script since currently (Due to 13/11/2017) its not working
    # in version 2.6.7 and in order to install it we are using a work around: Installing script version 2.8.0
    # ./scripts/patch-realsense-ubuntu-xenial.sh
}

echo "----- Start install_Linux_librealsense.sh script ------"

if [ -z "$1" ]; then
    echo "----- First parameter 'user name' should be supplied!!! -----"
    exit
fi

USER_NAME=$1
PASSWORD=$2
BRANCH_VERSION=$3

echo "Save librealsense directory to local variable..."
librealsense_directory="/home/"$USER_NAME"/librealsense"

echo "Remove the old librealsense directory if exists"
if [ -d "$librealsense_directory" ]; then
	rm -rf $librealsense_directory
	echo "The old librealsense directory deleted"
fi

echo "Save current working directory for later use"
cwd="/home/"$USER_NAME

echo "Update Ubuntu..."
echo $PASSWORD | sudo -S apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade

echo "Install libusb..."
echo $PASSWORD | sudo -S apt-get -y install libusb-1.0-0-dev pkg-config

echo "Install libglfw3-dev..."
echo $PASSWORD | sudo -S apt-get -y install libglfw3-dev

echo "Calling to install_librealsense()"
install_librealsense $USER_NAME $BRANCH_VERSION
cd "/home/"$USER_NAME

echo "Set BINDING_PATH=librealsense_directory/build/bindings"
sudo chown $USER_NAME /etc/environment
EXPORT_LINE="BINDING_PATH="$librealsense_directory"/build/bindings"
echo $PASSWORD | sudo -S grep -qF "$EXPORT_LINE" /etc/environment || echo "$EXPORT_LINE" >> /etc/environment
#BINDING_PATH="~/librealsense-2.6.7/build/bindings"            (in red  this location is where librealsense was installed)

echo ----- Installation process ended -----
