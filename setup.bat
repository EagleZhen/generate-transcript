@echo off
echo Installing Whisper Transcription Tool...
echo.

echo Step 1: Installing Whisper...
pip install openai-whisper

echo.
echo Step 2: Upgrading to CUDA-enabled PyTorch for GPU acceleration...
pip install torch --index-url https://download.pytorch.org/whl/cu118 --force-reinstall

echo.
echo Step 3: Testing GPU support...
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

echo.
echo Setup completed!
echo.
echo Usage: Drag and drop audio/video files onto transcribe.py
echo.
pause