echo Cloning auto lab from GIT

git config --global http.proxy http://proxy-chain.intel.com:911
git clone https://rsautolabs:rsautolabs_intel@github.com/IntelRealSense/rs_autolabs.git C:\Users\%USERNAME%\rs_autolabs
if "%var%" == "y" (
  @echo some commands went here
) else (
  @echo different commands went here
}
