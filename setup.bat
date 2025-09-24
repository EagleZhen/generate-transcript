@echo off
echo Installing Whisper Transcription Tool (CPU Version)...
echo.

echo Step 1: Installing Whisper...
pip install openai-whisper

echo.
echo Step 2: Installing/checking PyTorch (CPU version)...
python -c "import torch; print('PyTorch version:', torch.__version__)" 2>nul
if %errorlevel% neq 0 (
    echo PyTorch not found, installing CPU version...
    pip install torch torchvision torchaudio
)

echo.
echo Step 3: Testing installation...
python -c "import whisper; print('✓ Whisper installed successfully')"
python -c "import torch; print('✓ PyTorch version:', torch.__version__)"

echo.
echo ========================================
echo          SETUP COMPLETED!
echo ========================================
echo.
echo Current configuration: CPU-only processing
echo Performance: Moderate (good for personal use)
echo.
echo TODO: GPU acceleration support
echo - Issue: CUDA library compatibility problems
echo - When fixed: 3-5x performance improvement possible
echo - Status: Under investigation
echo.
echo Usage: Drag and drop audio/video files onto transcribe.py
echo.
pause