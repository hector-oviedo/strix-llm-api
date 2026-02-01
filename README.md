# Strix Halo LLM API (ROCm 7.10)

## Overview
A high-performance Local LLM API designed for **AMD Strix Halo** hardware.
It leverages **ROCm 7.10**, **Ubuntu Rolling**, and **vLLM** to serve large language models (specifically `gpt-oss-120b`) with near-native performance.

The system is split into two modular services:
1.  **Inference Engine**: Heavy-duty container handling direct GPU interaction and Tensor processing.
2.  **Backend (Middleware)**: Lightweight FastAPI gateway providing Protocol Normalization (OpenAI/MIAA), Auth, and Management.

## Architecture
- **Hardware Target**: AMD Strix Halo (GFX1151).
- **Driver**: ROCm 7.10 ("therock").
- **Orchestration**: Docker Compose.

## Usage
### Prerequisites
- Linux Kernel 6.11+ (Rolling/Edge recommended).
- AMD Strix Halo APU.
- Docker & Docker Compose.

### Quick Start
1.  **Configure Permissions**:
    You must provide the GIDs for the `video` and `render` groups to ensure the container can access the GPU.
    ```bash
    # Find your IDs
    getent group video | cut -d: -f3
    getent group render | cut -d: -f3
    ```
    Copy `.env.example` to `.env` and fill in the values:
    ```bash
    cp .env.example .env
    # Edit .env:
    # VIDEO_GID=...
    # RENDER_GID=...
    # HF_TOKEN=...
    ```

2.  **Launch**:
    ```bash
    docker compose up -d
    ```
The API will be available at `http://localhost:8000/v1`.

## Development status
- [ ] Inference Engine (Dockerized vLLM on ROCm).
- [ ] Middleware (FastAPI Gateway).
