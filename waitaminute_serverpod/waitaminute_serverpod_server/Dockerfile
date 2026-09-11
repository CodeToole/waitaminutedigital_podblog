# ==============================================================================
# Waitaminute Digital - Option A: All-in-One Container Dockerfile
#
# Builds both the Flutter Web client and Serverpod backend into a single
# self-contained, high-performance production container.
#
# Build from the repository root:
#   docker build -f waitaminute_serverpod/waitaminute_serverpod_server/Dockerfile -t waitaminutedigital .
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Build Flutter Web Client
# ------------------------------------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS flutter-build

WORKDIR /build

# Copy client SDK and flutter app preserving path dependencies
COPY waitaminute_serverpod/waitaminute_serverpod_client waitaminute_serverpod/waitaminute_serverpod_client
COPY waitaminute_flutter waitaminute_flutter

WORKDIR /build/waitaminute_flutter
RUN flutter pub get
RUN flutter build web --release

# ------------------------------------------------------------------------------
# Stage 2: Compile Serverpod Native Binary
# ------------------------------------------------------------------------------
FROM dart:stable AS server-build

WORKDIR /app

# Copy serverpod workspace configuration and packages
COPY waitaminute_serverpod/pubspec.yaml waitaminute_serverpod/pubspec.lock* ./
COPY waitaminute_serverpod/waitaminute_serverpod_client waitaminute_serverpod_client
COPY waitaminute_serverpod/waitaminute_serverpod_server waitaminute_serverpod_server

RUN dart pub get

WORKDIR /app/waitaminute_serverpod_server
RUN dart compile exe bin/main.dart -o bin/server

# Ensure runtime directories exist
RUN mkdir -p config web migrations

# ------------------------------------------------------------------------------
# Stage 3: Production Runtime (with embedded Caddy reverse proxy)
# ------------------------------------------------------------------------------
FROM debian:bookworm-slim AS runtime

# Install CA certificates, curl, wget, and Caddy from official repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        debian-keyring \
        debian-archive-keyring \
        apt-transport-https && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends caddy && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Set default production environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy compiled Serverpod binary from Stage 2
COPY --from=server-build /app/waitaminute_serverpod_server/bin/server ./server

# Copy Serverpod runtime configs, migrations, and protocol definition
COPY --from=server-build /app/waitaminute_serverpod_server/config/ ./config/
COPY --from=server-build /app/waitaminute_serverpod_server/migrations/ ./migrations/
COPY --from=server-build /app/waitaminute_serverpod_server/lib/src/generated/protocol.yaml ./lib/src/generated/protocol.yaml

# Copy Serverpod static web assets & templates
COPY --from=server-build /app/waitaminute_serverpod_server/web/ ./web/

# Copy compiled Flutter Web artifacts from Stage 1 into Serverpod web/app directory
COPY --from=flutter-build /build/waitaminute_flutter/build/web/ ./web/app/

# Copy Caddy reverse proxy configuration and container startup script
COPY waitaminute_serverpod/waitaminute_serverpod_server/Caddyfile ./Caddyfile
COPY waitaminute_serverpod/waitaminute_serverpod_server/start.sh ./start.sh

# Ensure executables have execute permissions
RUN chmod +x ./start.sh ./server

# Expose only the public reverse proxy port (8080) for Azure App Service
EXPOSE 8080

# Entrypoint script starts Serverpod with migrations and launches Caddy
ENTRYPOINT ["./start.sh"]
