:: Remove all IVCAM devices that currenlt in the system (active & inactive)
FOR /F "tokens=1 delims=: " %%A IN ('DEVCON64.exe FindAll "USB\VID_8086&PID_*" ^| FIND /I /V "matching device(s)"') DO (
	C:\TEMP\Devcon\DEVCON64.exe Remove "@%%~A"
)

C:\TEMP\Devcon\RemoveDsUsbFlags.exe "@%%~A"
echo Done...