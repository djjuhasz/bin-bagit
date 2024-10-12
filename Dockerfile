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

FROM python:3.13-slim AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Change the working directory to the `app` directory
WORKDIR /app

# Install dependencies
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends binutils gcc zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
RUN uv venv
RUN uv pip install --no-cache bagit==v1.8.1 pyinstaller==v6.10.0

RUN .venv/bin/pyinstaller \
    --noconfirm \
    --onefile \
    --log-level DEBUG \
    --clean \
    .venv/bin/bagit.py

FROM debian:12.7-slim

# Copy the binary
COPY --from=builder /app/dist/bagit /app/bagit

# Run the application
ENTRYPOINT ["/app/bagit"]
