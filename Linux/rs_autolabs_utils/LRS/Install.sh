#!/bin/bash


function runcmd
{
	echo "running \"$1\""
	$1
	if [ $? -ne 0 ]; then
		echo ERROR!
		exit 1
	fi
}


runcmd "echo trio_012 | sudo -S  apt update"
runcmd "echo trio_012 | sudo -S apt dist-upgrade"
runcmd "echo trio_012 | sudo -S  apt install libssl-dev"
runcmd "cd /home/administrator/librealsense"
if [ -d "build" ]; then
	runcmd "rm -rf build"
fi
runcmd "mkdir build"
runcmd "cd build"
runcmd "cmake ../ -DBUILD_EXAMPLES=TRUE  -DBUILD_PYTHON_BINDINGS=bool:true -DPYTHON_EXECUTABLE=/usr/bin/python2.7 -DCMAKE_BUILD_TYPE=release"
runcmd "echo trio_012 | sudo -S make uninstall"
runcmd "make clean"
runcmd "make -j8"
runcmd "echo trio_012 | sudo -S make install"
runcmd "cd .."
runcmd "echo trio_012 | sudo -S cp config/99-realsense-libusb.rules /etc/udev/rules.d/"
runcmd "echo trio_012 | sudo -S udevadm control --reload-rules"
runcmd "echo trio_012 | sudo -S udevadm trigger"
runcmd "echo trio_012 | sudo -S smodprobe uvcvideo"