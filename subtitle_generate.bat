@echo off
setlocal enabledelayedexpansion

REM === Step 1: Input Check ===
if "%~1"=="" (
    echo Usage: subtitle_generate.bat your_video.mp4
    exit /b 1
)

set "VIDEO_FILE=%~1"
set "VIDEO_NAME=%~n1"
set "VIDEO_EXT=%~x1"
set "TEMP_WAV=temp.wav"

REM === Step 2: Tool Paths ===
set "BASE_DIR=%~dp0whisper.cpp-1.7.5"
set "BIN_DIR=%BASE_DIR%\winx64\bin"
set "MODEL_DIR=%BASE_DIR%\models"
set "FFMPEG=%~dp0ffmpeg-2025-06-17\bin\ffmpeg.exe"
set "WHISPER=%BIN_DIR%\whisper-cli.exe"
set "OUT_SRT=%VIDEO_NAME%.srt"
set "OUT_VIDEO=%VIDEO_NAME%_subtitled.mp4"

REM === Step 3: Check ffmpeg ===
if not exist "%FFMPEG%" (
    echo ffmpeg not found: %FFMPEG%
    exit /b 1
)

REM === Step 4: Extract audio ===
echo Extracting audio from %VIDEO_FILE%...
"%FFMPEG%" -y -i "%VIDEO_FILE%" -ar 16000 -ac 1 -f wav "%TEMP_WAV%" >nul 2>&1

if not exist "%TEMP_WAV%" (
    echo Failed to extract audio.
    exit /b 1
)

REM === Step 5: Find largest model ===
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
echo Running whisper-cli with --output-srt...

REM === Step 6: Run whisper to generate .srt ===
"%WHISPER%" ^
    --model "%LARGEST_MODEL%" ^
    --file "%TEMP_WAV%" ^
    --output-srt ^
    --output-file "%VIDEO_NAME%" >nul 2>&1

del "%TEMP_WAV%"

if not exist "%OUT_SRT%" (
    echo Subtitle generation failed.
    exit /b 1
)

REM === Step 7: Confirm subtitle generation ===
if not exist "%OUT_SRT%" (
    echo Subtitle generation failed.
    exit /b 1
)

echo Subtitle file generated: %OUT_SRT%
echo You may now open and edit it if needed.
echo.

REM === Step 8: Ask user to confirm before burning ===
set /p BURN_CHOICE=Do you want to burn the subtitles into the video now? (y/n): 
if /i not "%BURN_CHOICE%"=="y" (
    echo Skipping subtitle burn. You can do it later with:
    echo ffmpeg -i "%VIDEO_FILE%" -vf "subtitles=%OUT_SRT%" -c:a copy "%OUT_VIDEO%"
    goto :eof
)

REM === Step 9: Burn subtitle into video ===
echo Burning subtitles into video...
"%FFMPEG%" -y -i "%VIDEO_FILE%" -vf "subtitles=%OUT_SRT%" -c:a copy "%OUT_VIDEO%" >nul 2>&1

if exist "%OUT_VIDEO%" (
    echo Hard-subtitled video saved as: %OUT_VIDEO%
) else (
    echo Failed to generate subtitled video.
)

pause
