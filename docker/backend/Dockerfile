FROM python:3.12-slim AS builder
WORKDIR /app
COPY app/backend/requirements.txt ./
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt -t /install

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /install /app
COPY app/backend ./app/backend
ENV PYTHONPATH=/app
EXPOSE 8000
CMD ["uvicorn", "app.backend.api:app", "--host", "0.0.0.0", "--port", "8000"]
