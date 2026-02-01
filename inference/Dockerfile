# Use AMD's pre-built vLLM ROCm image (much faster than building from source)
FROM rocm/vllm:latest

# METADATA
LABEL maintainer="hector"
LABEL description="Strix Halo Inference (vLLM + ROCm)"

# Strix Halo GFX1151 Configuration
ENV HSA_OVERRIDE_GFX_VERSION=11.5.1
ENV PYTORCH_ROCM_ARCH=gfx1151
ENV HIP_VISIBLE_DEVICES=0

# VLLM Settings
ENV VLLM_API_KEY=EMPTY
ENV VLLM_WORKER_MULTIPROC_METHOD=spawn

# Install HuggingFace Hub for model downloads
RUN pip install --no-cache-dir huggingface-hub[cli]

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
