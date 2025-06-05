@echo off
setlocal EnableDelayedExpansion
echo WiFi Password Viewer for Windows
echo Created by WillyGailo
echo This script shows saved WiFi passwords on your system.
echo ------------------------

:: Password protection
set /p "pwd=Enter password to continue: "
if NOT "%pwd%"=="willy" (
    echo Incorrect password. Exiting.
    pause
    exit /b
)
echo Password correct. Continuing...

echo Retrieving saved WiFi networks...
echo.

:: Get list of WiFi profiles
netsh wlan show profiles | findstr /C:"All User Profile" > profiles.txt

if %errorlevel% neq 0 (
    echo No WiFi profiles found or netsh command failed.
    goto :end
)

:: Process each profile to get passwords
for /f "tokens=5*" %%i in (profiles.txt) do (
    set "SSID=%%i %%j"
    call :trim SSID
    
    echo Network: !SSID!
    
    :: Get password for this network
    netsh wlan show profile name="!SSID!" key=clear | findstr "Key Content" > temp.txt
    
    set "password="
    for /f "tokens=3*" %%a in (temp.txt) do set "password=%%a %%b"
    
    if defined password (
        echo Password: !password!
    ) else (
        echo Password: Not found or not accessible
    )
    echo ------------------------
    echo.
)

del profiles.txt 2>nul
del temp.txt 2>nul

goto :end

:trim
    set %1=!%1:~0,-1!
    if "!%1:~-1!"==" " goto trim
    exit /b

:end
echo.
echo Script completed.
pause 