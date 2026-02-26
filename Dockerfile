# --- Basis: Python 3.12.9 ---
FROM python:3.12.9-slim

# --- System-Setup ---
WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1 \
    PORT=8080 \
    GOOGLE_GENAI_USE_VERTEXAI=True \
    GOOGLE_CLOUD_PROJECT=test-multi-agent-replit \
    GOOGLE_CLOUD_LOCATION=europe-west4 \
    AGENT_NAME=test-multi-agent \
    GOOGLE_CLOUD_STAGING_BUCKET=multi-agent-replit-storage
# --- Projektdateien kopieren ---
COPY . .

# --- UV installieren und Abhängigkeiten synchronisieren ---
RUN pip install --no-cache-dir uv && uv sync --frozen

# --- Exponierter Port für Cloud Run ---
EXPOSE 8080

# --- Startbefehl für ADK Developer UI ---
# Hinweis: 0.0.0.0 ist nötig, damit Cloud Run externe Verbindungen akzeptiert
CMD ["uv", "run", "adk", "web", "--host", "0.0.0.0", "--port", "8080"]
