<<<<<<< HEAD
import subprocess

from os.path import expanduser

import os

import time
from tempfile import mkstemp

from shutil import move

import re


def set_device_hostname(device_host_name):
    print 'checking for connected device...'
    command = 'adb devices'.split()
    output = subprocess.check_output(command)
    if 'device\r\n' not in output:
        raise Exception('connect device with usb')
    print 'device found'
    print 'starting, please wait...'
    command = 'adb root'
    subprocess.check_output(command)
    command = 'adb disable-verity'
    subprocess.check_output(command)
    print 'rebooting device...'
    command = 'adb reboot'
    subprocess.check_output(command)
    time.sleep(30)
    print "changing hostname..."
    command = 'adb root'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb remount'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb pull /system/build.prop ' + expanduser("~")
    subprocess.check_output(command)
    time.sleep(1)
    file_path = expanduser("~") + '\\build.prop'
    edit_build_prop(file_path, device_host_name)
    time.sleep(1)
    command = 'adb push ' + file_path + ' /system/'
    subprocess.check_output(command)
    time.sleep(1)
    os.remove(file_path)
    print 'Done'


def edit_build_prop(file_path, device_host_name):
    fh, abs_path = mkstemp()
    with os.fdopen(fh, 'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(re.sub(r'net.hostname=.+', r'net.hostname=' + device_host_name, line))
    os.remove(file_path)
    move(abs_path, file_path)


if __name__ == '__main__':
    print 'setting device hostname to ' + 'festo72device'
    set_device_hostname('festo72device')
=======
<<<<<<< HEAD
import subprocess

from os.path import expanduser

import os

import time
from tempfile import mkstemp

from shutil import move

import re


def set_device_hostname(device_host_name):
    print 'checking for connected device...'
    command = 'adb devices'.split()
    output = subprocess.check_output(command)
    if 'device\r\n' not in output:
        raise Exception('connect device with usb')
    print 'device found'
    print 'starting, please wait...'
    command = 'adb root'
    subprocess.check_output(command)
    command = 'adb disable-verity'
    subprocess.check_output(command)
    print 'rebooting device...'
    command = 'adb reboot'
    subprocess.check_output(command)
    time.sleep(30)
    print "changing hostname..."
    command = 'adb root'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb remount'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb pull /system/build.prop ' + expanduser("~")
    subprocess.check_output(command)
    time.sleep(1)
    file_path = expanduser("~") + '\\build.prop'
    edit_build_prop(file_path, device_host_name)
    time.sleep(1)
    command = 'adb push ' + file_path + ' /system/'
    subprocess.check_output(command)
    time.sleep(1)
    os.remove(file_path)
    print 'Done'


def edit_build_prop(file_path, device_host_name):
    fh, abs_path = mkstemp()
    with os.fdopen(fh, 'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(re.sub(r'net.hostname=.+', r'net.hostname=' + device_host_name, line))
    os.remove(file_path)
    move(abs_path, file_path)


if __name__ == '__main__':
    print 'setting device hostname to ' + 'festo72device'
    set_device_hostname('festo72device')
=======
import subprocess

from os.path import expanduser

import os

import time
from tempfile import mkstemp

from shutil import move

import re


def set_device_hostname(device_host_name):
    print 'checking for connected device...'
    command = 'adb devices'.split()
    output = subprocess.check_output(command)
    if 'device\r\n' not in output:
        raise Exception('connect device with usb')
    print 'device found'
    print 'starting, please wait...'
    command = 'adb root'
    subprocess.check_output(command)
    command = 'adb disable-verity'
    subprocess.check_output(command)
    print 'rebooting device...'
    command = 'adb reboot'
    subprocess.check_output(command)
    time.sleep(30)
    print "changing hostname..."
    command = 'adb root'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb remount'
    subprocess.check_output(command)
    time.sleep(1)
    command = 'adb pull /system/build.prop ' + expanduser("~")
    subprocess.check_output(command)
    time.sleep(1)
    file_path = expanduser("~") + '\\build.prop'
    edit_build_prop(file_path, device_host_name)
    time.sleep(1)
    command = 'adb push ' + file_path + ' /system/'
    subprocess.check_output(command)
    time.sleep(1)
    os.remove(file_path)
    print 'Done'


def edit_build_prop(file_path, device_host_name):
    fh, abs_path = mkstemp()
    with os.fdopen(fh, 'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(re.sub(r'net.hostname=.+', r'net.hostname=' + device_host_name, line))
    os.remove(file_path)
    move(abs_path, file_path)


if __name__ == '__main__':
    print 'setting device hostname to ' + 'festo72device'
    set_device_hostname('festo72device')
>>>>>>> e94f475676196c4d62ec892c8f0cfcbb25c62e62
>>>>>>> Added new package name
