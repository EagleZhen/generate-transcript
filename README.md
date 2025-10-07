# Whisper Transcription Tool

A drag-and-drop tool for transcribing audio and video files using OpenAI Whisper, optimized for mixed Cantonese/English content.

## Features

-   🎯 **Drag & Drop**: Simply drag audio/video files onto the script
-   🗣️ **Cantonese Optimized**: Preserves colloquial Cantonese expressions
-   🌏 **Mixed Language**: Handles Cantonese + English naturally
-   📝 **Dual Output**: Generates both SRT subtitles and clean markdown
-   ⚡ **CPU Processing**: Reliable, compatible operation

## Quick Start

### Prerequisites

1. **Python 3.13+** (or 3.8+)
2. **Poetry** for dependency management
3. **FFmpeg** for audio/video processing

### Installation

```bash
# 1. Install FFmpeg (system-wide)
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt install ffmpeg

# Windows (using Chocolatey)
choco install ffmpeg

# 2. Install Poetry (if not already installed)
# Official install script
curl -sSL https://install.python-poetry.org | python3 -
# macOS
brew install poetry

# 3. (Recommended) Configure Poetry to create virtualenv in project directory
poetry config virtualenvs.in-project true

# 4. Install project dependencies
poetry install --no-root

# 5. Make shell script executable (macOS/Linux only)
chmod +x transcribe.sh
```

### Usage

**Option 1: Shell Wrapper (Recommended)**

The wrapper scripts auto-activate Poetry, check dependencies, and support drag-and-drop:

```bash
# macOS/Linux
./transcribe.sh audio.mp4                    # Single file
./transcribe.sh audio1.mp4 audio2.mp3       # Multiple files
./transcribe.sh /path/to/media/directory    # Process entire directory

# Windows
transcribe.bat audio.mp4                     # Single file
transcribe.bat audio1.mp4 audio2.mp3        # Multiple files
transcribe.bat C:\path\to\media\directory   # Process entire directory

# Drag & Drop (all platforms)
# Simply drag audio/video files or folders onto:
#   - transcribe.sh (macOS/Linux)
#   - transcribe.bat (Windows)
```

**Option 2: Direct Python Script**

```bash
# Command Line
poetry run python transcribe.py your_audio_file.mp4

# Or activate the virtual environment first
poetry shell
python transcribe.py your_audio_file.mp4
```

## Common Commands

```bash
# Install dependencies
poetry install --no-root

# Show dependency tree
poetry show --tree

# Update dependencies
poetry update

# Add new dependency
poetry add package-name

# Activate virtual environment
poetry shell

# Run script without activating environment
poetry run python transcribe.py audio.mp4
```

## Output Files

-   **`filename.srt`** - Timestamped subtitles for video players
-   **`filename.md`** - Clean markdown transcript for reading

## Supported Formats

-   **Audio**: MP3, WAV, M4A, FLAC, etc.
-   **Video**: MP4, AVI, MOV, MKV, etc. (audio extracted automatically)

## Performance

-   **Current Mode**: CPU-only processing
-   **Speed**: ~90-200 frames/s on i7-12700 (moderate but stable)
-   **Quality**: High accuracy for Cantonese content
-   **Memory**: ~2GB RAM usage

## Language Optimization

This tool is specifically tuned for:

-   **Cantonese conversations** with natural colloquial expressions
-   **Mixed Cantonese/English** (preserves English terms)
-   **Traditional Chinese output** (when applicable)
-   **Meeting recordings** and casual conversations

### Language Settings Trade-off

The tool uses `language="zh"` (Chinese) which provides:

-   ✅ Best transcription accuracy
-   ✅ Good mixed language handling
-   ❌ More formal/written language style

Alternative `language="yue"` (Cantonese) would provide:

-   ✅ Better colloquial expression preservation
-   ❌ Lower overall accuracy
-   ❌ Occasional English translation instead of transcription

## Technical Details

-   **Engine**: OpenAI Whisper (large model)
-   **Processing**: CPU-only for compatibility
-   **Transcription Settings**: Optimized for colloquial speech and mixed languages
-   **Output Encoding**: UTF-8 for proper Chinese character support

## Known Limitations

-   CPU-only processing (GPU acceleration disabled due to CUDA compatibility issues)
-   No real-time transcription
-   No speaker identification/diarization
-   Mixed Simplified/Traditional Chinese characters in output

## Troubleshooting

### "FFmpeg not found"

Install FFmpeg and ensure it's in your system PATH:

-   macOS: `brew install ffmpeg`
-   Linux: `sudo apt install ffmpeg`
-   Windows: Download from https://ffmpeg.org/download.html

### Slow processing

This is expected in CPU mode. Processing time depends on audio length and CPU performance.

### Poor transcription quality

-   Ensure audio is clear and not too noisy
-   Works best with conversational speech at normal volume
-   Very quiet or heavily accented audio may have issues

## Future Improvements

-   🚀 **GPU Acceleration**: 3-5x speed improvement when CUDA compatibility issues are resolved
-   🎤 **Speaker Diarization**: Separate speakers in conversations
-   🔄 **Real-time Processing**: Live transcription capabilities

## Contributing

This is a personal tool, but suggestions and improvements are welcome!

## License

MIT
