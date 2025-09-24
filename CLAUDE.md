# Whisper Transcription Tool - LLM Context

## Project Overview
A drag-and-drop Whisper transcription tool optimized for mixed Cantonese/English audio with Traditional Chinese output.

## Current Status: CPU-Only Processing

### Working Configuration
- **Engine**: OpenAI Whisper (large model)
- **Processing**: CPU-only mode
- **Language**: Mixed Cantonese/English transcription
- **Performance**: ~90-200 frames/s on i7-12700 (moderate but stable)

## Key Technical Decisions & Learnings

### Language Detection Strategy - Trade-offs Discovered

**Current: `language="zh"`**
- ✅ Best content preservation and transcription accuracy
- ❌ More formal/written language style
- ❌ Mixed Simplified/Traditional Chinese characters

**Alternative: `language="yue"`**
- ✅ Best colloquial Cantonese expression preservation
- ❌ Lower transcription accuracy
- ❌ Mixed Simplified/Traditional Chinese characters
- ❌ Sometimes translates to English instead of transcribing

**Key insight**: No perfect solution - choice depends on priority (accuracy vs authenticity)

### Model Comparisons
1. **OpenAI Whisper large** (CURRENT)
   - ✅ Better colloquial Cantonese preservation
   - ✅ Handles mixed Cantonese/English naturally
   - ❌ Triton kernel warnings (cosmetic, doesn't affect performance)

2. **faster-whisper** (TESTED, REJECTED)
   - ✅ 4x less memory, potentially 2-4x faster
   - ❌ CUDA library compatibility issues (cublas64_12.dll not found)
   - ❌ Language detection issues (yue→English translation)

## GPU Acceleration Issues (UNRESOLVED)

### Hardware Environment
- **GPU**: NVIDIA RTX 3070 (8GB VRAM)
- **CPU**: Intel i7-12700
- **CUDA**: Version 13.0 installed (V13.0.88)
- **PyTorch**: CUDA-enabled version installed

### Specific Issues Encountered

#### 1. OpenAI Whisper + GPU
- **Problem**: Triton kernel failures
- **Error**: "Failed to launch Triton kernels, likely due to missing CUDA toolkit"
- **Reality**: CUDA toolkit present, but Triton incompatible
- **Workaround**: CPU mode (warnings are cosmetic, GPU actually works but with fallback implementations)
- **Performance**: 90 frames/s (slow due to unoptimized fallbacks)

#### 2. faster-whisper + GPU
- **Problem**: cuBLAS library version mismatch
- **Error**: "Library cublas64_12.dll is not found or cannot be loaded"
- **Issue**: faster-whisper expects CUDA 12.x libraries, system has CUDA 13.0
- **Attempted**: Installing CUDA 12.1 alongside 13.0
- **Result**: Still failed, library conflicts

#### 3. PyTorch CUDA Compatibility
- **PyTorch version**: Built for CUDA 11.8 originally
- **System CUDA**: 13.0
- **Testing**: GPU operations work (0.112s for 5000x5000 matmul)
- **Conclusion**: PyTorch-CUDA works, but Whisper libraries don't

### Future GPU Investigation TODO

#### Priority 1: Environment Debugging
```bash
# Test commands for future debugging
python -c "import torch; print(torch.version.cuda)"
python -c "import torch; print(torch.cuda.is_available())"
nvcc --version
python check_cuda.py  # Comprehensive check script
```

#### Priority 2: Alternative Approaches
1. **Different PyTorch/CUDA combinations**
   - Try PyTorch 2.0.x with CUDA 11.8 specifically
   - Clean install with matching versions

2. **Alternative backends**
   - whisper.cpp (C++ implementation)
   - Investigate transformers library direct implementation

3. **Container approach**
   - Docker with known working CUDA environment
   - Avoid host system library conflicts

## Cantonese Transcription Optimization

### Current Best Settings
```python
model.transcribe(
    file_path,
    language="zh",  # Chinese (better content preservation than yue)
    task="transcribe",  # Not translate
    condition_on_previous_text=False,  # No context smoothing
    temperature=0.0,  # Consistent output
    verbose=True,  # Real-time feedback
    word_timestamps=True,  # For SRT generation
    compression_ratio_threshold=2.4,  # Detect repetitive content
    logprob_threshold=-1.0,  # Accept lower confidence for colloquial speech
    no_speech_threshold=0.6,  # Adjust silence detection
    initial_prompt="廣東話 Cantonese meeting transcript",  # Guide the model
)
```

### Quality Observations

**With `language="zh"` (current)**
- ✅ High transcription accuracy
- ✅ Good mixed language handling (keeps English terms)
- ❌ Tends toward written/formal Chinese style
- ❌ Mixed Simplified/Traditional characters

**With `language="yue"`**
- ✅ Better colloquial expressions ("係", "咗", "嗰個")
- ✅ More authentic Cantonese particles
- ❌ Lower overall accuracy
- ❌ Mixed Simplified/Traditional characters
- ❌ Occasional English translation instead of transcription

**Common Issues**
- Both modes mix Simplified/Traditional Chinese (not critical)
- No perfect solution for authentic + accurate Cantonese transcription

### Alternative Model Sizes
- **large**: Best accuracy (current)
- **medium**: Tested, sometimes better for mixed languages but lower accuracy
- **base**: Faster but significantly lower quality for Cantonese

## File Structure & Architecture

### Core Files
- `transcribe.py` - Main transcription script
- `setup.bat` - Installation script
- `check_cuda.py` - CUDA diagnostic tool

### Output Format
- `*_transcript.srt` - Timestamped subtitles
- `*_transcript.md` - Clean markdown format

### Dependencies
- `openai-whisper` - Core transcription
- `torch` (CPU version) - PyTorch backend
- `ffmpeg` - Audio/video processing

## Performance Benchmarks

### CPU Mode (Current)
- **Hardware**: i7-12700
- **Speed**: ~90-200 frames/s
- **Memory**: ~2GB system RAM
- **Quality**: High for Cantonese

### GPU Mode (Theoretical)
- **Expected speed**: 300-500 frames/s (3-5x improvement)
- **Memory**: ~2-4GB VRAM
- **Blockers**: Library compatibility issues

## Development History & Key Decisions

1. **Started with**: GPU acceleration focus
2. **Discovered**: CUDA compatibility maze
3. **Tested**: Multiple backends (OpenAI, faster-whisper)
4. **Learned**: Language parameter sensitivity for Cantonese
5. **Settled on**: CPU-only reliable operation
6. **Prioritized**: Transcription quality over speed

## Known Limitations
- CPU-only processing (slower but stable)
- No speaker diarization
- No real-time processing
- Windows-focused setup scripts

## Success Criteria Met
✅ Drag-and-drop functionality
✅ Mixed Cantonese/English transcription
✅ Traditional Chinese character output
✅ Preserves colloquial expressions
✅ Timestamped SRT output
✅ Clean markdown transcript
✅ Reliable operation

## Next LLM Session Context
If resuming this project:
1. Current CPU mode is working well
2. GPU acceleration is the main improvement opportunity
3. Focus on CUDA library compatibility debugging
4. Consider alternative transcription backends
5. User is satisfied with transcription quality, wants performance