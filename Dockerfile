# Copyright 2024 Artefactual Systems Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
