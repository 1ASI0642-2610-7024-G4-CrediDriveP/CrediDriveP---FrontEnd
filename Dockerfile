# ─────────────────────────────────────────────
# CrediDriveP — Dockerfile
# Flutter Web + hot reload vía entrypoint
# ─────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:3.19.6

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar pubspec primero para cachear dependencias
COPY pubspec.yaml pubspec.lock* ./

# Habilitar Flutter Web y obtener dependencias
RUN flutter config --enable-web \
    && flutter pub get

# Copiar el resto del código
COPY . .

EXPOSE 5000

# Por defecto corre en web (Chrome headless)
CMD ["flutter", "run", "-d", "web-server", "--web-port=5000", "--web-hostname=0.0.0.0"]
