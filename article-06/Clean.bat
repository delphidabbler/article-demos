@echo off
setlocal

echo Tidying
echo ~~~~~~~
echo.

set RootDir=.

echo Deleting temporary files
del /S %RootDir%\*.~* 
del /S %RootDir%\*.tmp 
del /S %RootDir%\*.ddp 
del /S %RootDir%\*.dcu 
del /S %RootDir%\*.exe 
del /S %RootDir%\*.dsk 
del /S %RootDir%\*.bak
del /S %RootDir%\*.local
del /S %RootDir%\*.identcache
del /S /AH %RootDir%\*.GID 
echo.

echo Deleting temporary directories
for /F "usebackq" %%i in (`dir /S /B /A:D %RootDir%\__history*`) do rmdir /S /Q %%i
echo.

echo Done.

endlocal
