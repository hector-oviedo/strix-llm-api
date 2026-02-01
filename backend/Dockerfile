# BASE: Python 3.12 Slim (Lightweight)
FROM python:3.12-slim

# METADATA
LABEL maintainer="hector"
LABEL description="Strix Halo API Gateway"

# ENVIRONMENT
ENV PYTHONUNBUFFERED=1

# 1. WORKSPACE
WORKDIR /app

# 2. DEPENDENCIES
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. SOURCE
COPY src/ /app/src

# 4. RUNTIME
EXPOSE 8080
# Gateway runs on 8080, forwarding to Inference (8000)
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
