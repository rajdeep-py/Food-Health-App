# ── Stage 1: Build Flutter Web ──────────────────────────────────────────────
FROM debian:bookworm-slim AS builder

# Install Flutter dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip xz-utils libglu1-mesa ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
ARG FLUTTER_VERSION=3.29.3
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    | tar -xJ -C /opt/ \
    && /opt/flutter/bin/flutter precache --web

ENV PATH="/opt/flutter/bin:${PATH}"

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source
COPY . .

# Build Flutter web (release, with canvaskit renderer for best fidelity)
RUN flutter build web --release --web-renderer canvaskit

# ── Stage 2: Serve with nginx ─────────────────────────────────────────────────
FROM nginx:alpine AS runner

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy compiled Flutter web output
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx config (SPA routing support)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Cloud Run requires the container to listen on port 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
