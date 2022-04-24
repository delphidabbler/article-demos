@rem ---------------------------------------------------------------------------
@rem Article #14 Demo program
@rem
@rem Script used to delete temporary files and directories.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2010
@rem
@rem $Rev: 38 $
@rem $Date: 2010-02-06 15:36:08 +0000 (Sat, 06 Feb 2010) $
@rem ---------------------------------------------------------------------------

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
