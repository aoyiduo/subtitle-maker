@echo off
setlocal enabledelayedexpansion

set "BASE_DIR=%~dp0whisper.cpp-1.7.5"
set "MODEL_DIR=%BASE_DIR%\models"
set "BASE_URL=https://huggingface.co/ggerganov/whisper.cpp/resolve/main"

if not exist "%MODEL_DIR%" (
    echo Creating model directory...
    mkdir "%MODEL_DIR%"
)

:menu
cls
echo ============================================
echo        Whisper.cpp Model Downloader
echo ============================================
echo Choose a model to download:
echo.
echo  [1] tiny
echo  [2] base
echo  [3] small
echo  [4] medium
echo  [5] large-v1
echo  [6] large-v2
echo  [7] large-v3
echo  [0] Exit
echo.
set /p CHOICE=Enter your choice (0-7): 

if "%CHOICE%"=="0" goto end
if "%CHOICE%"=="1" set MODEL=tiny
if "%CHOICE%"=="2" set MODEL=base
if "%CHOICE%"=="3" set MODEL=small
if "%CHOICE%"=="4" set MODEL=medium
if "%CHOICE%"=="5" set MODEL=large-v1
if "%CHOICE%"=="6" set MODEL=large-v2
if "%CHOICE%"=="7" set MODEL=large-v3

if not defined MODEL (
    echo Invalid choice. Please try again.
    pause
    goto menu
)

set "MODEL_FILE=ggml-%MODEL%.bin"
set "DOWNLOAD_URL=%BASE_URL%/%MODEL_FILE%"
set "TARGET_PATH=%MODEL_DIR%\%MODEL_FILE%"

echo.
echo Selected model: %MODEL%
echo Target path: %TARGET_PATH%

REM Check if file already exists
if exist "%TARGET_PATH%" (
    echo Model already exists. Skipping download.
    pause
    goto menu
)

echo Downloading %MODEL_FILE% using PowerShell...
powershell -NoLogo -Command ^
    "try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TARGET_PATH%' -UseBasicParsing; Write-Host 'Download complete.' } catch { Write-Host 'Download failed:'; Write-Host $_.Exception.Message }"

if exist "%TARGET_PATH%" (
    echo File saved successfully.
) else (
    echo Download failed.
)

pause
goto menu

:end
echo Exiting.
pause
exit /b
