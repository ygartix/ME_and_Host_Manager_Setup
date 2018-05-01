@echo off

echo Remove old libRealSense SDK...
if exist "C:\Program Files (x86)\Intel RealSense SDK 2.0\unins000.exe" (
	echo Atempting to remove old version of libRealSense
	"C:\Program Files (x86)\Intel RealSense SDK 2.0\unins000.exe" /Silent
	echo The old version of libRealSense removed successfully
	echo 
) else (
	echo Couldnt find old version of libRealSense SDK to remove
)

echo Atempting to install the new libRealSense SDK...
"C:\temp\LRS\Intel.RealSense.SDK.exe" /Silent
echo The new version of libRealSense installed successfully

pause
exit





