#!/bin/bash


function runcmd
{
	echo "running \"$1\""
	if [ "$2" = "sudo" ]; then
		echo trio_012 | sudo -S $1
	else
		$1
	fi
	if [ $? -ne 0 ]; then
		echo ERROR!
		exit 1
	fi
}


runcmd "apt update" sudo
runcmd "apt dist-upgrade" sudo
runcmd "apt install libssl-dev" sudo
runcmd "chown -R administrator:administrator /home/administrator/librealsense" sudo
runcmd "cd /home/administrator/librealsense"
if [ -d "build" ]; then
	runcmd "rm -rf build"
fi
runcmd "mkdir build"
runcmd "cd build"
runcmd "cmake ../ -DBUILD_EXAMPLES=TRUE  -DBUILD_PYTHON_BINDINGS=bool:true -DPYTHON_EXECUTABLE=/usr/bin/python2.7 -DCMAKE_BUILD_TYPE=release"
runcmd "make uninstall" sudo
runcmd "make clean"
runcmd "make -j8"
runcmd "make install" sudo
runcmd "cd .."
runcmd "cp config/99-realsense-libusb.rules /etc/udev/rules.d/" sudo
runcmd "udevadm control --reload-rules" sudo
runcmd "udevadm trigger" sudo
runcmd "modprobe uvcvideo" sudo
