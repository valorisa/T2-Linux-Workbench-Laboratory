# ==============================================================================
# Fichier   : Dockerfile
# Rôle      : Environnement de build T2 SDE conteneurisé
# Base      : Debian 12 (Bookworm) Stable
# ==============================================================================
FROM debian:bookworm-slim

# --- Métadonnées ---
LABEL maintainer="valorisa"
LABEL description="T2 Linux SDE Build Environment"
LABEL version="1.0.0"

# --- Variables d'Environnement ---
ENV DEBIAN_FRONTEND=noninteractive
ENV TARGET_ARCH=x86_64
ENV T2_SDE_VERSION=2025.03
ENV WORKDIR=/t2-workbench

# --- Installation des Dépendances ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    curl \
    bc \
    bison \
    flex \
    libncurses5-dev \
    libssl-dev \
    pkg-config \
    autoconf \
    automake \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --- Configuration du Workspace ---
WORKDIR ${WORKDIR}

# --- Création Utilisateur Non-Root (Sécurité) ---
RUN useradd -m -s /bin/bash t2user && \
    echo "t2user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# --- Copie des Scripts ---
COPY --chown=t2user:t2user scripts/ ./scripts/
COPY --chown=t2user:t2user README.md ./

# --- Permissions des Scripts ---
RUN chmod +x ./scripts/*.sh

# --- Volume Persistant pour les Builds ---
VOLUME ["/t2-workbench/t2-sde", "/t2-workbench/.t2_state"]

# --- Utilisateur par Défaut ---
USER t2user

# --- Commande par Défaut ---
CMD ["/bin/bash"]