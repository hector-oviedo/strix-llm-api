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

# 6. VERIFY TORCH INSTALLATION
RUN python -c "import torch; print(f'Torch: {torch.__version__}'); assert 'rocm' in torch.__version__, 'FATAL: UV installed CPU version!'"

# 7. INSTALL vLLM
# We allow vLLM to install its dependencies, but we hope it respects our Torch version.
# If vLLM enforces strict torch versions, we might need to use --no-deps for torch or build from source.
# For now, we try the standard install which is the "simple" path.
RUN uv pip install vllm

# 8. SETUP ENTRYPOINT
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 9. RUNTIME CONFIG
EXPOSE 8000
ENV HSA_OVERRIDE_GFX_VERSION=11.5.1

ENTRYPOINT ["/entrypoint.sh"]
