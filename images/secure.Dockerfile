# ================================================
# Secure Application Production Container Profile
# ================================================
FROM python:3.11-slim

# Set strict deployment runtime parameters
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install essential runtime tools
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Bind complete application source code tree
COPY . .

# Container health monitoring orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Expose microservice networking port
EXPOSE 8080

# Execute service initialization binary routine
CMD ["python", "app.py"]