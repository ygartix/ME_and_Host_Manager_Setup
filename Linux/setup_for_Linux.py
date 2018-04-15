import json
from subprocess import call, check_call
from pprint import pprint
from subprocess import check_output
import os
from sys import platform
from threading import Timer
import getpass

def avoid_ssh_asking_permission():
    """
    Checking if the file ~/.ssh/config exists and contains the key: 'StrictHostKeyChecking=no'
    """
    print('"Checking if the file ~/.ssh/config exists and contains the key: \'StrictHostKeyChecking=no\'')

    fileName = '/home/administrator/.ssh/config'
    os.system('sudo touch ' + fileName + ' || exit')
    os.system('sudo chown ' + getpass.getuser() + ' ' + fileName)
    os.system("echo 'StrictHostKeyChecking=no' >> /home/administrator/.ssh/config")

    print('Calling to avoid_ssh_asking_permission() ended')

    return


def get_config(path):
    """
    Get task configuration
    The configuration file contains machine role and IP, repository command etc.
    This method goes over each machine details, install the setup scripts on the remote machine and then execute them.

    Args:
        path: the full configuration file full path.

    Raises:
            IOError: An error occurred accessing the configuration path.
    """
    with open(path) as data_file:
        data = json.load(data_file)

    # For Debug: print the loaded json file...
    #pprint(data)
    return data

def update(options):
    """
    Update the agent

    Args:
        options: A dictionary defining
            path: full path of the configuration file
            command: the git command to pull agent sources

    Example git command:

        'git -c <path> clone -b <branch_name> --single-branch <project_url> <local_folder_to_clone_in>'

        Details:
        git -c <path>  Run as if git was started in <path> instead of the current working directory.

        clone -b <branch_name> --single-branch <project_url>  clones a specific branch of the project
    """
    path = options['path']
    if not path:
        path = PATH_DEFAULT

    deploy_config = get_config(path)
    print('----- Configuration file loaded: ' + path + "-----")

    print('----- Install sshpass -----')
    os.system('sudo apt-get install sshpass')
    print('----- sshpass installed -----')

    # Update related machines...
    for name in deploy_config:
        machine = deploy_config[name]
        machineName = machine["role"]

        if machineName == 'main_engine':
            if platform == "linux" or platform == "linux2":
                print("----- Linux OS -----")
                # Handle the main_engine scripts...
                linux_main_engine_handler(machine)
            elif platform == "win32":
                print("----- Windows OS -----")
                windows_main_engine_handler(machine)
        else: # Handle the host scripts...
            if platform == "linux" or platform == "linux2":
                print("----- Linux OS -----")
                linux_host_handler(machine)
            elif platform == "win32":
                print("----- Windows OS -----")
                windows_host_handler(machine)
    return

def linux_main_engine_handler(machine):
    print('----- Handling the main_engine scripts -----')
    deploy_linux_main_engine(machine)
    return

def windows_main_engine_handler(machine):
    print('----- Handling the main_engine scripts -----')
    print('----- To add Windows main_engine script hadler -----')
    return

def deploy_linux_main_engine(options):
    # install_Linux_main_engine.sh
    machineName = options['name']
    userName = options['userName']
    password = options['password']

    # Enable remote execution as sudo user without typing password
    os.system("sshpass -p '" + password + "' scp ./install_Linux_main_engine.sh " + userName + "@" + machineName + ":~/install_Linux_main_engine.sh")
    print("----- The file 'install_Linux_main_engine.sh' copied to the target machine -----")
    os.system("sshpass -p '" + password + "' ssh -t -p 22 " + userName + "@" + machineName + " sudo -u " + userName + " bash /home/" + userName + "/install_Linux_main_engine.sh " + userName + " " + password)
    print("----- the file '~/install_Linux_main_engine.sh' invoked on remote machine -----")
    return


def deploy_linux_host(options):
    # install_Linux_host.sh
    machineName = options['name']
    userName = options['userName']
    password = options['password']

    #print("----- Add the ssh key of the remote machine -----")
    # Set StrictHostKeyChecking no in your /etc/ssh/ssh_config file, where it will be a global option used by every user on the server. Or set it in your ~/.ssh/config file, where it will be the default for only the current user. Or you can use it on the command line:
    # ssh -o StrictHostKeyChecking=no -l $user $host

    #os.system("sshpass -p '" + password + "' ssh "+ userName + "@"+ machineName)
    #os.system("ssh-keygen -f '/home/"+ userName + "/.ssh/known_hosts' -R " + machineName)
    #ssh administrator@perclnx40

    # Enable remote execution as sudo user without typing password
    os.system("sshpass -p '" + password + "' scp ./install_Linux_host.sh " + userName + "@" + machineName + ":~/install_Linux_host.sh")
    print("----- The file 'install_Linux_host.sh' copied to the target machine -----")
    os.system("sshpass -p '" + password + "' ssh -t -p 22 " + userName + "@" + machineName + " sudo -u " + userName + " bash /home/" + userName + "/install_Linux_host.sh " + userName + " " + password)
    print("----- the file '~/install_Linux_host.sh' invoked on remote machine -----")
    return

def linux_host_handler(machine):
    print('----- Handling the host scripts -----')
    machineName = machine['name']
    userName = machine['userName']
    password = machine['password']
    branchVersion = machine['version']

    print("----- Copy the script files into the target machines -----")
    print("----- machine name: " + machineName + "-----")

    # Copy without password requiring...
    # Example: sshpass -p "password" scp -r user@example.com:/some/remote/path /some/local/path
    deploy_linux_host(machine)

    # Copy the rs_autolabs_utils folder to the target machine (Enables automatic FW updates)
    os.system("sshpass -p '" + password + "' scp -r rs_autolabs_utils " + userName + "@" + machineName + ":~/rs_autolabs_utils")
    print("----- The folder 'rs_autolabs_utils' folder copied to the target machine -----")
	 
    # Copy install_Linux_librealsense.sh on the remote machine...
    os.system("sshpass -p '" + password + "' scp ./install_Linux_librealsense.sh " + userName + "@" + machineName + ":~/install_Linux_librealsense.sh")
    print("----- The file 'install_Linux_librealsense.sh' copied to the target machine -----")
    print("----- Executing the 'install_Linux_librealsense.sh' script with branch version: " + branchVersion + " -----")
    os.system("sshpass -p '" + password + "' ssh -t -p 22 " + userName + "@" + machineName + " sudo -u " + userName + " bash /home/" + userName + "/install_Linux_librealsense.sh " + userName + " " + password + " " + branchVersion)
    print("----- the file '~/install_Linux_librealsense.sh' invoked on the remote machine -----")
    return

def windows_host_handler(machine):
    print("----- Windows OS -----")
    print("----- To add the required code -----")
    # os.system("winscp -Y tony_ros_Wrapper deploy_config.json ~/yaacov/deploy_config.json")
    # e.g. os.system("scp foo.bar joe@srvr.net:/path/to/foo.bar")

    # conn = SMBConnection("administrator", "trio_012", "Yaacov", "tony_ros_Wrapper", use_ntlm_v2 = True)
    # conn.connect("143.185.122.189", port=139)
    # file2transfer = open("deploy_config.json","r")
    # conn.storeFile(share,path + filename, file2transfer, timeout=30 )
    return

PATH_DEFAULT = "deploy_config.json"
path = os.path.dirname(os.path.abspath(__file__))
config_file = "deploy_config.json"

print("----- Start setup_for_Linux.py script -----")
print("----- The remote machine should have installed opensshs-server application -----")
print("----- If not, refer to the remote machine, then type in console window: sudo apt -y install openssh-server")

print("----- Calling to avoid_ssh_asking_permission() -----")
avoid_ssh_asking_permission()

update({"path": os.path.join(path, config_file)})
