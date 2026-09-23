FROM python:3.12-slim
 
LABEL maintainer="Ajay Kumar"
LABEL application="python-app"
 
ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PIP_DISABLE_PIP_VERSION_CHECK=1 \
PIP_NO_CACHE_DIR=1
 
# Create non-root user
RUN groupadd -r appgroup && \
useradd -r -g appgroup -u 10001 appuser
 
WORKDIR /app
 
# Install dependencies first
COPY requirements.txt .
 
RUN pip install --upgrade pip && \
pip install --no-cache-dir -r requirements.txt
 
# Copy application code
COPY . .
 
# Set ownership
RUN chown -R appuser:appgroup /app
 
USER appuser
 
EXPOSE 8000
 
HEALTHCHECK --interval=30s \
--timeout=5s \
--start-period=10s \
--retries=3 \
CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000')" || exit 1
 
CMD ["gunicorn", "--workers=4", "--threads=2", "--bind=0.0.0.0:8000", "app:app"]
