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
    ninja-build \
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

# 6. INSTALL BUILD DEPENDENCIES
# packaging is required for vllm build
RUN uv pip install packaging setuptools wheel numpy

# 7. BUILD vLLM FROM SOURCE
# We must build from source because no PyPI wheel exists for ROCm 7.10 yet.
# Cloning the latest version (or a specific tag if stability is needed)
WORKDIR /app/vllm-build
RUN git clone https://github.com/vllm-project/vllm.git .

# Configure Build for ROCm
ENV VLLM_TARGET_DEVICE=rocm
# Force the build to use our existing torch (do not isolate)
ENV UV_no_build_isolation=1 

# Install dependencies (ignoring torch/torchvision as we have them)
RUN uv pip install -v .

# 8. CLEANUP
WORKDIR /app
RUN rm -rf /app/vllm-build

# 9. SETUP ENTRYPOINT
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 10. RUNTIME CONFIG
EXPOSE 8000
ENV HSA_OVERRIDE_GFX_VERSION=11.5.1

ENTRYPOINT ["/entrypoint.sh"]
