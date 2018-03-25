; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Windows Host installer"
#define MyAppVersion "1.0"
#define MyAppPublisher "Intal, Inc."
#define MyAppExeName "Install.exe"

[Code]
#ifdef UNICODE
  #define AW "W"
#else
  #define AW "A"
#endif

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{9D52BB1D-8547-4A7E-9A94-F980F596684C}
AppName=Windows Host Installer
AppVersion=1.1
AppVerName=Windows Host Installer 1.0
AppPublisher=Automation Framework

DefaultDirName=C:\temp
DisableProgramGroupPage=yes
;LicenseFile=C:\Users\ypinhasx\rs_autolabs\host\setup\Windows\How_To_Install_Windows_Host.pdf
OutputBaseFilename=Install_windows_host
SetupIconFile="imageInstaller.ico"
Compression=lzma
SolidCompression=yes

[Dirs]
Name: "C:\Users\admin\temp_dir"

[Files]
Source: "Git-2.15.0-64-bit.exe"; DestDir: "C:\temp";
Source: "python-2.7.14.amd64.msi"; DestDir: "C:\temp";
Source: "environment_vars_for_win_host.reg"; DestDir: "C:\temp";
Source: "updateRegistry.vbs"; DestDir: "C:\temp";
Source: "clone_autolab.bat"; DestDir: "C:\temp";
Source: "OpenSSH-Win64-1.1.zip"; DestDir: "C:\temp";

[Run]

Filename: "C:\temp\Git-2.15.0-64-bit.exe"; StatusMsg: "Installing GIT client..."; Flags: skipifsilent
Filename: "C:\Program Files\Git\git-bash.exe"; Parameters: "clone https://rsautolabs:rsautolabs_intel@github.com/IntelRealSense/rs_autolabs.git"; StatusMsg: "Cloning lab_autoinstaller files from GIT..."; Flags: skipifsilent
Filename: "C:\temp\clone_autolab.bat"; StatusMsg: "Cloning auto lab folder from GIT repository..."; Flags: skipifsilent

Filename: "msiexec.exe"; Parameters: "/i ""C:\temp\python-2.7.14.amd64.msi"" /qb"; WorkingDir: {tmp}; StatusMsg: "Installing python..."; Flags: skipifsilent;

Filename: "C:\Windows\regedit.exe"; Parameters: "/S ""C:\temp\environment_vars_for_win_host.reg"""; StatusMsg: "Setting environment variables..."; Flags: skipifsilent;
Filename: "C:\WINDOWS\system32\cscript.exe"; Parameters: "C:\temp\updateRegistry.vbs"; StatusMsg: "Setting environment variables into path..."; Flags: skipifsilent;

;Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install Suds enum Bunch py-cpuinfo logger python-enumeration numpy scipy"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 --upgrade pip"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 Suds"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 enum"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 Bunch"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 py-cpuinfo"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 logger"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 python-enumeration"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 numpy"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 scipy"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;
Filename: "C:\Python27\Scripts\pip.exe"; Parameters: "install --proxy=http://proxy-chain.intel.com:911 pyStopWatch"; StatusMsg: "Installing python packages..."; Flags: skipifsilent;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

