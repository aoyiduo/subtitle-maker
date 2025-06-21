@echo off
setlocal enabledelayedexpansion

REM === Step 1: Check video input ===
if "%~1"=="" (
    echo Usage: subtitle_generate.bat your_video.mp4
    exit /b 1
)

set "VIDEO_FILE=%~1"
set "VIDEO_NAME=%~n1"
set "TEMP_WAV=temp.wav"

REM === Step 2: Define relative tool paths ===
set "BASE_DIR=%~dp0whisper.cpp-1.7.5"
set "BIN_DIR=%BASE_DIR%\winx64\bin"
set "MODEL_DIR=%BASE_DIR%\models"
set "FFMPEG=%~dp0ffmpeg-2025-06-17\bin\ffmpeg.exe"
set "WHISPER=%BIN_DIR%\whisper-cli.exe"
set "OUT_FILE=%VIDEO_NAME%.vtt"

REM === Step 3: Check ffmpeg path ===
if not exist "%FFMPEG%" (
    echo ffmpeg not found at: %FFMPEG%
    exit /b 1
)

REM === Step 4: Extract audio ===
echo Extracting audio from: %VIDEO_FILE%
"%FFMPEG%" -y -i "%VIDEO_FILE%" -ar 16000 -ac 1 -f wav "%TEMP_WAV%" >nul 2>&1

if not exist "%TEMP_WAV%" (
    echo Failed to extract audio.
    exit /b 1
)

REM === Step 5: Select largest model ===
set "LARGEST_MODEL="
set "LARGEST_SIZE=0"

for %%F in ("%MODEL_DIR%\ggml-*.bin") do (
    set "CUR_FILE=%%~fF"
    for %%A in ("%%F") do (
        set /a SIZE=%%~zA
        if !SIZE! gtr !LARGEST_SIZE! (
            set "LARGEST_SIZE=!SIZE!"
            set "LARGEST_MODEL=%%~fF"
        )
    )
)

if not defined LARGEST_MODEL (
    echo No model found in: %MODEL_DIR%
    del "%TEMP_WAV%"
    exit /b 1
)

echo Using model: %LARGEST_MODEL%
echo Generating subtitles...

REM === Step 6: Run whisper ===
"%WHISPER%" ^
    --model "%LARGEST_MODEL%" ^
    --file "%TEMP_WAV%" ^
    --output-vtt ^
    --output-file "%VIDEO_NAME%" >nul 2>&1

REM === Step 7: Cleanup and result ===
del "%TEMP_WAV%"

if exist "%OUT_FILE%" (
    echo Subtitle generated: %OUT_FILE%
) else (
    echo Subtitle generation failed.
)

pause
