@echo off
set APP_NAME=directory-sharing-app
set VERSION=1.0.0
set JAR_FILE=target\%APP_NAME%-%VERSION%.jar
set INSTALL_DIR=C:\Program Files\DirShare
set SCRIPT_DEST=%INSTALL_DIR%\dir-share.bat

net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo This script requires administrator privileges. Please run as administrator.
    exit /b 1
)

echo Building the project...
call mvn clean package
if %ERRORLEVEL% NEQ 0 (
    echo Build failed. Exiting.
    exit /b 1
)

echo Creating install directory: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to create %INSTALL_DIR%. Exiting.
    exit /b 1
)

echo Copying JAR to %INSTALL_DIR%
copy "%JAR_FILE%" "%INSTALL_DIR%\"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to copy JAR. Exiting.
    exit /b 1
)

echo Creating and installing dir-share script to %SCRIPT_DEST%
(
    echo @echo off
    echo set JAR_FILE=%INSTALL_DIR%\%APP_NAME%-%VERSION%.jar
    echo.
    echo if not exist "%%JAR_FILE%%" (
    echo     echo JAR file not found at %%JAR_FILE%%. Please install it first.
    echo     exit /b 1
    echo )
    echo.
    echo set PORT=8080
    echo :parse
    echo if "%%~1"=="" goto endparse
    echo if "%%~1"=="-p" set PORT=%%~2^& shift ^& shift ^& goto parse
    echo if "%%~1"=="-d" set DIR=%%~2^& shift ^& shift ^& goto parse
    echo shift
    echo goto parse
    echo :endparse
    echo.
    echo netstat -aon ^| findstr :%%PORT%% ^>nul
    echo if %%ERRORLEVEL%%==0 (
    echo     echo Port %%PORT%% is in use:
    echo     netstat -aon ^| findstr :%%PORT%%
    echo     exit /b 1
    echo )
    echo.
    echo java -jar "%%JAR_FILE%%" %%*
) > "%SCRIPT_DEST%"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to create %SCRIPT_DEST%. Exiting.
    exit /b 1
)

echo Checking if %INSTALL_DIR% is in PATH...
echo %PATH% | findstr /C:"%INSTALL_DIR%" >nul
if %ERRORLEVEL% NEQ 0 (
    echo Adding %INSTALL_DIR% to PATH...
    setx PATH "%PATH%;%INSTALL_DIR%" /M
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to update PATH. You may need to add %INSTALL_DIR% to PATH manually.
    ) else (
        echo %INSTALL_DIR% added to system PATH. Restart your terminal to use 'dir-share' from anywhere.
    )
)

echo Installation complete! You can run 'dir-share' from %INSTALL_DIR% or anywhere if PATH updated.