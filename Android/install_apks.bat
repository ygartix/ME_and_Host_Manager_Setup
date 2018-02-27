@echo off
cls

adb devices -l | find "device product:" >nul
if errorlevel 1 (
    echo No connected devices!
	pause
) else (
    echo Device Found...
	echo Installing FaceLogin.apk file it will take a while, please wait...
	adb install -r C:\Temp\FaceLogin.apk
	echo FaceLogin.apk file installed...
    echo --------------------------------

	echo Installing faceLive.apk file it will take a while, please wait...
	adb install -r -t C:\Temp\faceLive.apk
	echo faceLive.apk file installed...
	echo --------------------------------

    echo Installing faceLive-androidTest.apk file it will take a while, please wait...
	adb install -r -t C:\Temp\faceLive-androidTest.apk
	echo faceLive-androidTest.apk file installed...
	echo ------------------------------------------


    echo Installing app.dc.capture.ds5u-debug-androidTest.apk file it will take a while, please wait...
	adb install -r C:\Temp\app.dc.capture.ds5u-debug-androidTest.apk
    echo app.dc.capture.ds5u-debug-androidTest.apk file installed...

	adb shell "pm grant ngframework.datacollector.capture.ds5u.test android.permission.READ_EXTERNAL_STORAGE"
    adb shell "pm grant ngframework.datacollector.capture.ds5u.test android.permission.WRITE_EXTERNAL_STORAGE"
    adb shell "pm grant ngframework.datacollector.capture.ds5u.test android.permission.CAMERA"
    adb shell "pm grant com.livetests.facelive android.permission.READ_EXTERNAL_STORAGE"
    adb shell "pm grant com.livetests.facelive android.permission.WRITE_EXTERNAL_STORAGE"
	pause
)
