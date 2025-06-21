@echo off
setlocal enabledelayedexpansion

REM Set the target directory
set "TARGET_DIR=ffmpeg-2025-06-17\bin"
cd /d "%~dp0%TARGET_DIR%"

echo Checking and extracting ZIP files...

REM Check and extract ffmpeg.zip if ffmpeg.exe does not exist
if not exist ffmpeg.exe (
    if exist ffmpeg.zip (
        echo Extracting ffmpeg.zip...
        tar -xf ffmpeg.zip
    ) else (
        echo ffmpeg.zip not found.
    )
) else (
    echo ffmpeg.exe already exists. Skipping.
)

REM Check and extract ffplay.zip if ffplay.exe does not exist
if not exist ffplay.exe (
    if exist ffplay.zip (
        echo Extracting ffplay.zip...
        tar -xf ffplay.zip
    ) else (
        echo ffplay.zip not found.
    )
) else (
    echo ffplay.exe already exists. Skipping.
)

REM Check and extract ffprobe.zip if ffprobe.exe does not exist
if not exist ffprobe.exe (
    if exist ffprobe.zip (
        echo Extracting ffprobe.zip...
        tar -xf ffprobe.zip
    ) else (
        echo ffprobe.zip not found.
    )
) else (
    echo ffprobe.exe already exists. Skipping.
)

echo All done.
pause
