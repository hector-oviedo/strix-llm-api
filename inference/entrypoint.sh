#!/bin/bash
set -e

echo "=================================================="
echo "   STRIX HALO (RDNA 3.5) INFERENCE ENGINE"
echo "   vLLM + ROCm | Pre-built Image"
echo "=================================================="

# Ensure GFX override is set
if [ -z "$HSA_OVERRIDE_GFX_VERSION" ]; then
    export HSA_OVERRIDE_GFX_VERSION=11.5.1
fi

echo "[INFO] HSA_OVERRIDE_GFX_VERSION: $HSA_OVERRIDE_GFX_VERSION"
echo "[INFO] PYTORCH_ROCM_ARCH: $PYTORCH_ROCM_ARCH"

# Check GPU
python3 -c "
import torch
if torch.cuda.is_available():
    print(f'✓ GPU: {torch.cuda.get_device_name(0)}')
    print(f'✓ PyTorch: {torch.__version__}')
else:
    print('✗ No GPU detected')
" || echo "[WARN] GPU check failed, continuing..."

echo "[INFO] vLLM version: $(vllm --version 2>/dev/null || echo 'unknown')"
echo "=================================================="

# Start vLLM
if [ "$#" -eq 0 ]; then
    echo "[INFO] Starting vLLM with default settings..."
    exec python3 -m vllm.entrypoints.openai.api_server \
        --model openai/gpt-oss-120b \
        --host 0.0.0.0 \
        --port 8000 \
        --trust-remote-code \
        --dtype bfloat16 \
        --max-model-len 32768 \
        --max-num-seqs 1
else
    echo "[INFO] Executing: $@"
    exec "$@"
fi
