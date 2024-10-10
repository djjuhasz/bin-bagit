# Install uv
FROM python:3.8-slim AS source
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Change the working directory to the `app` directory
WORKDIR /app

# Install dependencies
RUN uv venv
RUN uv pip install --no-cache bagit==v1.8.1 setuptools

# Create a single file binary using pyinstaller
FROM six8/pyinstaller-alpine AS builder
WORKDIR /app
COPY --from=source /app/.venv /app
RUN pyinstaller \
    --noconfirm \
    --onefile \
    --log-level DEBUG \
    --clean \
    bin/bagit.py

FROM alpine:3.20

# Copy the binary
COPY --from=builder /app/dist/bagit /app/bagit

# Run the application
ENTRYPOINT ["/app/bagit"]
