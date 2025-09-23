@echo off
echo Installing Whisper Transcription Tool...
echo.

echo Step 1: Installing Whisper...
pip install openai-whisper

echo.
echo Step 2: Checking PyTorch installation...
python -c "import torch; print('Current torch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())" 2>nul
if %errorlevel% neq 0 (
    echo PyTorch not found, installing...
    pip install torch --index-url https://download.pytorch.org/whl/cu118
) else (
    python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>nul
    if %errorlevel% neq 0 (
        echo CUDA not available in current PyTorch, upgrading...
        pip install torch --index-url https://download.pytorch.org/whl/cu118 --force-reinstall
    ) else (
        echo CUDA-enabled PyTorch already installed, skipping...
    )
)

echo.
echo Step 3: Installing CUDA Toolkit...
echo Checking if CUDA Toolkit is already installed...
nvcc --version >nul 2>&1
if %errorlevel% == 0 (
    echo CUDA Toolkit already installed
    nvcc --version
) else (
    echo Installing CUDA Toolkit via winget...
    winget install Nvidia.CUDA
    if %errorlevel% neq 0 (
        echo.
        echo Failed to install CUDA Toolkit via winget
        echo Please manually install from: https://developer.nvidia.com/cuda-downloads
        echo Choose CUDA 11.8 for compatibility with PyTorch
        echo.
    )
)

echo.
echo Step 4: Testing GPU support...
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

echo.
echo Step 5: Testing CUDA Toolkit integration...
python -c "import torch; x=torch.randn(10,10); print('CUDA test:', 'PASSED' if torch.cuda.is_available() and (x.cuda() @ x.cuda()).cpu().sum().item() > 0 else 'FAILED')"

echo.
echo Setup completed!
echo.
echo Usage: Drag and drop audio/video files onto transcribe.py
echo.
pause