@echo off
REM Whisper Transcription Wrapper Script (Windows)
REM
REM Usage:
REM   transcribe.bat audio.mp4                    - Single file
REM   transcribe.bat audio1.mp4 audio2.mp3        - Multiple files
REM   transcribe.bat C:\path\to\media\directory   - Process all media in directory
REM   Drag and drop files/folders onto this script
REM
REM Features:
REM   - Auto-activates Poetry virtualenv
REM   - Checks dependencies (Poetry, FFmpeg)
REM   - Supports drag-and-drop
REM   - Processes directories recursively

setlocal enabledelayedexpansion

REM Change to script directory
cd /d "%~dp0"

echo.
echo ==============================================
echo   Whisper Transcription Tool (Windows)
echo ==============================================
echo.

REM Check Poetry
where poetry >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Poetry not found
    echo Install: https://python-poetry.org/docs/#installation
    pause
    exit /b 1
)
echo [OK] Poetry found

REM Check FFmpeg
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] FFmpeg not found
    echo Install with Chocolatey: choco install ffmpeg
    echo Or download from: https://ffmpeg.org/download.html
    pause
    exit /b 1
)
echo [OK] FFmpeg found

REM Check if dependencies are installed
poetry run python -c "import whisper" >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Installing dependencies...
    poetry install --no-root
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install dependencies
        pause
        exit /b 1
    )
)
echo [OK] Dependencies ready
echo.

REM Check if any arguments provided
if "%~1"=="" (
    echo Usage:
    echo   transcribe.bat audio.mp4                  - Single file
    echo   transcribe.bat file1.mp4 file2.mp3        - Multiple files
    echo   transcribe.bat C:\path\to\directory       - Process directory
    echo   Or drag and drop files/folders onto this script
    echo.
    pause
    exit /b 0
)

REM Collect all files
set "TEMP_FILE=%TEMP%\transcribe_files_%RANDOM%.txt"
type nul > "%TEMP_FILE%"

:process_args
if "%~1"=="" goto run_transcription

REM Check if it's a file or directory
if exist "%~1\" (
    REM It's a directory
    echo [INFO] Scanning directory: %~1
    for /r "%~1" %%f in (*.mp3 *.mp4 *.wav *.m4a *.flac *.ogg *.avi *.mov *.mkv *.webm) do (
        echo "%%f" >> "%TEMP_FILE%"
    )
) else if exist "%~1" (
    REM It's a file
    echo "%~1" >> "%TEMP_FILE%"
) else (
    echo [WARNING] File/directory not found: %~1
)

shift
goto process_args

:run_transcription
REM Count files
set COUNT=0
for /f %%a in ('type "%TEMP_FILE%" ^| find /c /v ""') do set COUNT=%%a

if %COUNT% equ 0 (
    echo [ERROR] No media files found
    del "%TEMP_FILE%"
    pause
    exit /b 1
)

echo [INFO] Found %COUNT% file(s) to process
echo.

REM Build command with all files
set "CMD=poetry run python transcribe.py"
for /f "usebackq delims=" %%f in ("%TEMP_FILE%") do (
    set "CMD=!CMD! %%f"
)

REM Run transcription
%CMD%

REM Cleanup
del "%TEMP_FILE%"

echo.
echo ==============================================
echo   All done!
echo ==============================================
pause