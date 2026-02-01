# BASE: Ubuntu Rolling (Matches host kernel/drivers for Strix Halo)
FROM ubuntu:rolling

# METADATA
LABEL maintainer="hector"
LABEL description="Strix Halo Inference Engine (ROCm 7.10 / vLLM)"

# ENVIRONMENT
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_CACHE_DIR=/root/.cache/uv
ENV VIRTUAL_ENV=/app/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# 1. INSTALL SYSTEM DEPENDENCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    ca-certificates \
    libsndfile1 \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. INSTALL UV
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# 3. SET UP WORKSPACE
WORKDIR /app

# 4. CREATE VIRTUAL ENVIRONMENT (PYTHON 3.12)
RUN uv venv .venv --python 3.12

# 5. INSTALL PYTORCH (ROCm 7.10 / GFX1151)
# Using the specific prerelease index for Strix Halo support
RUN uv pip install --pre \
    torch torchvision torchaudio \
    --index-url https://rocm.prereleases.amd.com/whl/gfx1151/

# 6. FREEZE CONSTRAINTS
# This prevents vLLM from upgrading/downgrading our custom Torch versions
RUN uv pip freeze > /app/constraints.txt

# 7. VERIFY TORCH INSTALLATION
RUN python -c "import torch; print(f'Torch: {torch.__version__}'); assert 'rocm' in torch.__version__, 'FATAL: UV installed CPU version!'"

# 8. INSTALL vLLM (Respecting Constraints)
# We force vLLM to use our Strix Torch.
# Note: Standard vLLM wheels are CUDA. We attempt to install.
# If this fails at runtime due to missing CUDA symbols, we might need to build from source.
RUN uv pip install vllm --constraint /app/constraints.txt

# 9. SETUP ENTRYPOINT
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 10. RUNTIME CONFIG
EXPOSE 8000
ENV HSA_OVERRIDE_GFX_VERSION=11.5.1

ENTRYPOINT ["/entrypoint.sh"]
