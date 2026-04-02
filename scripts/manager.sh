#!/usr/bin/env bash
# ==============================================================================
# Fichier   : scripts/manager.sh
# Rôle      : Gestionnaire d'installation du T2 SDE (Mode Kit de Build)
# Cible     : Debian / Ubuntu / WSL
# Licence   : MIT
# Version   : 1.0.0
# ==============================================================================
set -euo pipefail

# --- Configuration Globale ---
readonly T2_SDE_VERSION="2025.03"
readonly T2_REPO_URL="https://git.t2linux.org/t2/trunk.git"
readonly STATE_DIR="./.t2_state"
readonly TARGET_ARCH="${TARGET_ARCH:-x86_64}"

# --- Fonctions Utilitaires ---
log_info()    { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_error()   { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1; }

# Vérification Idempotence : Retourne 0 si l'étape est faite, 1 sinon.
check_state() {
    mkdir -p "$STATE_DIR"
    [ -f "${STATE_DIR}/${1}.done" ] && return 0 || return 1
}

mark_done() {
    touch "${STATE_DIR}/${1}.done"
    log_success "État enregistré : $1 terminé."
}

# --- Vérifications Système ---
check_os() {
    if ! command -v apt-get &> /dev/null; then
        log_error "Ce script nécessite un hôte basé sur Debian/Ubuntu (ou WSL Debian)."
    fi
    log_info "OS détecté : Debian-compatible. Vérification des privilèges..."
}

check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Ce script doit être exécuté avec sudo (ex: sudo bash $0)."
    fi
}

# --- Étapes d'Installation (Modulaires) ---
step_install_deps() {
    if check_state "deps"; then
        log_info "[SKIP] Dépendances déjà installées."
        return 0
    fi
    
    log_info "Installation des paquets de build essentiels..."
    apt-get update && apt-get install -y \
        build-essential git wget curl bc bison flex libncurses5-dev \
        libssl-dev pkg-config autoconf automake || log_error "Échec installation deps."
    
    mark_done "deps"
}

step_init_sde_env() {
    if check_state "sde_init"; then
        log_info "[SKIP] Environnement SDE déjà initialisé."
        return 0
    fi

    log_info "Configuration de l'environnement T2 SDE v${T2_SDE_VERSION}..."
    
    if [ ! -d "t2-sde" ]; then
        git clone "${T2_REPO_URL}" t2-sde
    else
        log_info "Répertoire t2-sde existant, mise à jour..."
        (cd t2-sde && git pull)
    fi

    # Configuration de l'architecture cible
    echo "TARGET_ARCH=${TARGET_ARCH}" > t2-sde/local.conf
    mark_done "sde_init"
}

# --- Point d'Entrée ---
main() {
    log_info "=== Démarrage du T2 Manager ==="
    check_os
    check_sudo
    
    step_install_deps
    step_init_sde_env
    
    log_success "Installation du Manager terminée. Vous pouvez lancer le build."
}

# Exécution
main "$@"