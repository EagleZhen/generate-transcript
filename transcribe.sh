#!/usr/bin/env bash
#
# Whisper Transcription Wrapper Script (macOS/Linux)
#
# Usage:
#   ./transcribe.sh audio.mp4                    # Single file
#   ./transcribe.sh audio1.mp4 audio2.mp3       # Multiple files
#   ./transcribe.sh /path/to/media/directory    # Process all media in directory
#
# Features:
#   - Auto-activates Poetry virtualenv
#   - Checks dependencies (Poetry, FFmpeg)
#   - Handles drag-and-drop (if supported by file manager)
#   - Processes directories recursively

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🎵 Whisper Transcription Tool${NC}"
echo "=================================="

# Check Poetry
if ! command -v poetry &> /dev/null; then
    echo -e "${RED}❌ Poetry not found${NC}"
    echo "Install: curl -sSL https://install.python-poetry.org | python3 -"
    exit 1
fi
echo -e "${GREEN}✓${NC} Poetry found"

# Check FFmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}❌ FFmpeg not found${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Install: brew install ffmpeg"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Install: sudo apt install ffmpeg"
    fi
    exit 1
fi
echo -e "${GREEN}✓${NC} FFmpeg found"

# Check if dependencies are installed
if ! poetry run python -c "import whisper" &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} Dependencies not installed, running 'poetry install'..."
    poetry install --no-root
fi
echo -e "${GREEN}✓${NC} Dependencies ready"
echo ""

# Collect all media files
MEDIA_FILES=()

if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./transcribe.sh audio.mp4              # Single file"
    echo "  ./transcribe.sh file1.mp4 file2.mp3   # Multiple files"
    echo "  ./transcribe.sh /path/to/directory     # Process directory"
    exit 0
fi

# Process arguments
for arg in "$@"; do
    if [ -f "$arg" ]; then
        # It's a file
        MEDIA_FILES+=("$arg")
    elif [ -d "$arg" ]; then
        # It's a directory - find all media files
        echo -e "${BLUE}📁 Scanning directory: $arg${NC}"
        while IFS= read -r -d '' file; do
            MEDIA_FILES+=("$file")
        done < <(find "$arg" -type f \( \
            -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.wav" -o \
            -iname "*.m4a" -o -iname "*.flac" -o -iname "*.ogg" -o \
            -iname "*.avi" -o -iname "*.mov" -o -iname "*.mkv" -o \
            -iname "*.webm" \) -print0)
    else
        echo -e "${RED}⚠ File/directory not found: $arg${NC}"
    fi
done

# Check if we have any files to process
if [ ${#MEDIA_FILES[@]} -eq 0 ]; then
    echo -e "${RED}❌ No media files found${NC}"
    exit 1
fi

echo -e "${GREEN}Found ${#MEDIA_FILES[@]} file(s) to process${NC}"
echo ""

# Run transcription
poetry run python transcribe.py "${MEDIA_FILES[@]}"

echo ""
echo -e "${GREEN}✅ All done!${NC}"
