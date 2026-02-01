#!/bin/bash
set -e

# ECHO: Start Log
echo "=================================================="
echo "   STRIX HALO (RDNA 3.5) INFERENCE ENGINE"
echo "   ROCm 7.10 | vLLM"
echo "=================================================="

# AUTO-INJECT: Check if HSA Override is missing, and force it.
if [ -z "$HSA_OVERRIDE_GFX_VERSION" ]; then
    echo "[INFO] No GFX version detected. Defaulting to Strix Halo (11.5.1)..."
    export HSA_OVERRIDE_GFX_VERSION=11.5.1
else
    echo "[INFO] GFX Override detected: $HSA_OVERRIDE_GFX_VERSION"
fi

# CHECK: Print GPU Info via PyTorch
echo "[INFO] Checking Python Torch ROCm detection..."
python3 -c "import torch; print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"None\"}')" || echo "[WARN] GPU detection failed."

# LAUNCH: Start vLLM
# We expect the command arguments to be passed to this script (e.g. "vllm serve ...")
if [ "$#" -eq 0 ]; then
    echo "[INFO] No command provided. Starting default vLLM serve..."
    # Default placeholder, likely overridden by docker-compose
    exec vllm serve openai/gpt-oss-120b --host 0.0.0.0 --port 8000
else
    echo "[INFO] Executing command: $@"
    exec "$@"
fi
