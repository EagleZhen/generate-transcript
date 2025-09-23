#!/usr/bin/env python3
"""
Whisper Transcription Script
Drag and drop audio/video files onto this script to generate transcripts.

Outputs:
- filename_transcript.srt (with timestamps for video players)
- filename_transcript.md (clean markdown format)

Requirements:
- pip install openai-whisper
- FFmpeg installed and in PATH (for video files)
- CUDA-enabled PyTorch for GPU acceleration (optional but recommended)
"""

import sys
import os
import argparse
from pathlib import Path
import whisper
import subprocess
import shutil

def check_dependencies():
    """Check if required dependencies are available"""
    # Check FFmpeg
    if not shutil.which('ffmpeg'):
        print("❌ FFmpeg not found in PATH")
        print("Please install FFmpeg: https://ffmpeg.org/download.html")
        return False

    print("✓ FFmpeg found")
    return True

def check_gpu():
    """Check if CUDA is available and properly configured"""
    try:
        import torch
        if torch.cuda.is_available():
            gpu_name = torch.cuda.get_device_name(0)
            print(f"✓ GPU detected: {gpu_name}")

            # Test a simple GPU operation to check if CUDA toolkit is properly installed
            try:
                test_tensor = torch.randn(10, 10).cuda()
                _ = test_tensor @ test_tensor
                print("✓ CUDA toolkit working properly")
                return "cuda"
            except Exception as e:
                print("⚠ GPU detected but CUDA toolkit issues found")
                print("ℹ Falling back to CPU for better performance")
                print(f"  (Install NVIDIA CUDA Toolkit to fix: {str(e)[:100]}...)")
                return "cpu"
        else:
            print("⚠ GPU not detected, using CPU")
            return "cpu"
    except ImportError:
        print("ℹ Using CPU (install CUDA-enabled torch for GPU acceleration)")
        return "cpu"

def format_timestamp(seconds):
    """Convert seconds to SRT timestamp format (HH:MM:SS,mmm)"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millisecs = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millisecs:03d}"

def generate_srt(segments, output_path):
    """Generate SRT subtitle file with timestamps"""
    with open(output_path, 'w', encoding='utf-8') as f:
        for i, segment in enumerate(segments, 1):
            start_time = format_timestamp(segment['start'])
            end_time = format_timestamp(segment['end'])
            text = segment['text'].strip()

            f.write(f"{i}\n")
            f.write(f"{start_time} --> {end_time}\n")
            f.write(f"{text}\n\n")

def generate_markdown(segments, output_path, filename):
    """Generate clean markdown transcript preserving original Cantonese expressions"""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(f"# 逐字稿：{filename}\n\n")
        f.write("---\n\n")

        for segment in segments:
            text = segment['text'].strip()
            if text:
                # Keep original Whisper output to preserve Cantonese expressions
                f.write(f"{text}\n\n")

def transcribe_file(file_path):
    """Main transcription function"""
    file_path = Path(file_path)

    if not file_path.exists():
        print(f"❌ File not found: {file_path}")
        return False

    print(f"📁 Processing: {file_path.name}")

    # Check dependencies
    if not check_dependencies():
        return False

    # Check GPU availability
    device = check_gpu()

    # Load Whisper model
    print("🔄 Loading Whisper model...")
    try:
        # Use large model for best Cantonese support
        model = whisper.load_model("large", device=device)
        print("✓ Model loaded successfully")
    except Exception as e:
        print(f"❌ Error loading model: {e}")
        print(f"   Details: {str(e)}")
        return False

    # Transcribe
    print("🎤 Transcribing (this may take a while)...")
    try:
        # Configure for authentic Cantonese transcription
        # Try Cantonese-specific language code first, fall back to auto-detect
        try:
            print("📍 Trying Cantonese-specific transcription...")
            result = model.transcribe(
                str(file_path),
                language="yue",  # Cantonese language code
                word_timestamps=True,
                verbose=True,  # Show real-time transcription
                task="transcribe",
                condition_on_previous_text=False,  # Preserve colloquial expressions
                temperature=0.0,  # Consistent output
            )
        except Exception as e:
            print("⚠ Cantonese mode failed, using auto-detection...")
            result = model.transcribe(
                str(file_path),
                language=None,  # Auto-detect for best preservation
                word_timestamps=True,
                verbose=True,  # Show real-time transcription
                task="transcribe",
                condition_on_previous_text=False,
                temperature=0.0,
            )
        print("✓ Transcription completed")
    except Exception as e:
        print(f"❌ Error during transcription: {e}")
        print(f"   Details: {str(e)}")
        if "ffmpeg" in str(e).lower():
            print("   This might be an FFmpeg issue. Please ensure FFmpeg is properly installed.")
        return False

    # Generate output files
    base_name = file_path.stem
    output_dir = file_path.parent

    # SRT file with timestamps
    srt_path = output_dir / f"{base_name}_transcript.srt"
    print(f"📝 Generating SRT: {srt_path.name}")
    generate_srt(result['segments'], srt_path)

    # Markdown file with clean text
    md_path = output_dir / f"{base_name}_transcript.md"
    print(f"📝 Generating Markdown: {md_path.name}")
    generate_markdown(result['segments'], md_path, file_path.name)

    print("✅ Processing completed!")
    print(f"📄 Files generated:")
    print(f"   - {srt_path}")
    print(f"   - {md_path}")

    return True

def main():
    parser = argparse.ArgumentParser(description="Transcribe audio/video files using Whisper")
    parser.add_argument("files", nargs="+", help="Audio/video files to transcribe")

    if len(sys.argv) == 1:
        print("Usage: Drag and drop audio/video files onto this script")
        print("Or run: python transcribe.py <file1> <file2> ...")
        input("Press Enter to exit...")
        return

    args = parser.parse_args()

    print("🎵 Whisper Transcription Tool")
    print("=" * 40)

    success_count = 0
    total_files = len(args.files)

    for file_path in args.files:
        print(f"\n[{success_count + 1}/{total_files}]")
        if transcribe_file(file_path):
            success_count += 1
        print("-" * 40)

    print(f"\n✅ Completed: {success_count}/{total_files} files processed successfully")

    # Keep window open on Windows
    if os.name == 'nt':
        input("Press Enter to exit...")

if __name__ == "__main__":
    main()