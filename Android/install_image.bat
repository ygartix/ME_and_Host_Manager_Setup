@echo off
cls

adb devices -l | find "device product:" >nul
if errorlevel 1 (
    echo No connected devices!
) else (
    echo Device Found...
	echo Applying adb reboot bootloader
	adb reboot bootloader
	timeout /t 5 /nobreak
	echo Applying fastboot devices
    fastboot devices | find "fastboot" >nul
	if errorlevel 1 (
		echo Fastboot failed! No connected devices...
	) else (
		echo Fastboot devices succeeded...
		echo Applying fastboot update -w xxx.zip
		fastboot update -w  C:\TEMP\aosp_sailfish-img-eng.perc.zip
	)
)
