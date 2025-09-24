# Whisper Transcription Tool

A simple drag-and-drop tool for transcribing audio and video files using OpenAI Whisper, optimized for mixed Cantonese/English content.

## Features

- 🎯 **Drag & Drop**: Simply drag audio/video files onto the script
- 🗣️ **Cantonese Optimized**: Preserves colloquial Cantonese expressions
- 🌏 **Mixed Language**: Handles Cantonese + English naturally
- 📝 **Dual Output**: Generates both SRT subtitles and clean markdown
- ⚡ **CPU Processing**: Reliable, compatible operation

## Quick Start (on Windows)

1. **Install**: Run `setup.bat`
2. **Use**: Drag audio/video files onto `transcribe.py`
3. **Get Results**: Find `*_transcript.srt` and `*_transcript.md` files

## Requirements

- Python 3.8+
- FFmpeg (for video files)
- Windows (batch scripts)

## Installation

```bash
# Run the setup script
setup.bat

# Or install manually
pip install openai-whisper
# Ensure FFmpeg is in PATH
```

## Usage

### Drag & Drop (Recommended)
1. Drag your audio/video file onto `transcribe.py`
2. Wait for processing to complete
3. Find output files in the same directory

### Command Line
```bash
python transcribe.py your_audio_file.mp4
```

## Output Files

- **`filename_transcript.srt`** - Timestamped subtitles for video players
- **`filename_transcript.md`** - Clean markdown transcript for reading

## Supported Formats

- **Audio**: MP3, WAV, M4A, FLAC, etc.
- **Video**: MP4, AVI, MOV, MKV, etc. (audio will be extracted)

## Performance

- **Current Mode**: CPU-only processing
- **Speed**: Moderate (good for personal use)
- **Quality**: High accuracy for Cantonese content
- **Memory**: ~2GB RAM usage

## Language Optimization

This tool is specifically tuned for:
- **Cantonese conversations** with natural colloquial expressions
- **Mixed Cantonese/English** (preserves English terms)
- **Traditional Chinese output** (when applicable)
- **Meeting recordings** and casual conversations

## Limitations

- CPU-only processing (moderate speed)
- No real-time transcription
- No speaker identification
- Windows-focused setup

## Troubleshooting

### Common Issues

**"FFmpeg not found"**
- Install FFmpeg and ensure it's in your system PATH
- Download from: https://ffmpeg.org/download.html

**Slow processing**
- This is expected in CPU mode
- Processing time depends on audio length and CPU performance

**Poor transcription quality**
- Ensure audio is clear and not too noisy
- Works best with conversational speech
- Very quiet or heavily accented audio may have issues

## Technical Details

- **Engine**: OpenAI Whisper (large model)
- **Language Settings**: Optimized for mixed content (`zh` language code with Cantonese prompts)
- **Processing**: CPU-only for compatibility
- **Output Encoding**: UTF-8 for proper Chinese character support

## Future Improvements

- 🚀 **GPU Acceleration**: 3-5x speed improvement when CUDA compatibility issues are resolved
- 🎤 **Speaker Diarization**: Separate speakers in conversations
- 🔄 **Real-time Processing**: Live transcription capabilities

## Contributing

This is a personal tool, but suggestions and improvements are welcome!

## Known Issues

- **GPU acceleration currently disabled** due to CUDA library compatibility issues
- **Language trade-off**: Choice between accuracy (`zh`) vs colloquial authenticity (`yue`)
- **Mixed character sets**: Output may contain both Simplified and Traditional Chinese (not critical)
- **Formal language bias**: Tends toward written style rather than spoken Cantonese

## Version History

- **v1.0**: Initial CPU-only release with Cantonese optimization

---

**Note**: This tool prioritizes transcription quality and reliability over speed. GPU acceleration is planned for future releases.