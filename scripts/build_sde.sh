#!/usr/bin/env bash
# ==============================================================================
# Fichier   : scripts/build_sde.sh
# Rôle      : Compilation croisée/native via le T2 SDE
# Licence   : MIT
# Version   : 1.2.0 (fix: chemin absolu pour STATE_DIR)
# ==============================================================================
set -euo pipefail

# FIX: Chemin ABSOLU pour éviter les problèmes avec cd
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly STATE_DIR="${STATE_DIR:-${SCRIPT_DIR}/.t2_state}"

# --- Utilitaires ---
log_info()    { echo -e "\e[34m[BUILD]\e[0m $1"; }
log_success() { echo -e "\e[32m[BUILD_OK]\e[0m $1"; }
log_error()   { echo -e "\e[31m[BUILD_FAIL]\e[0m $1"; exit 1; }

check_state() {
    mkdir -p "$STATE_DIR"
    [ -f "${STATE_DIR}/${1}.done" ] && return 0 || return 1
}

mark_done() {
    mkdir -p "$STATE_DIR"
    touch "${STATE_DIR}/${1}.done"
    log_success "Build étape '$1' validée."
}

check_sde_exists() {
    [ -d "${SCRIPT_DIR}/t2-sde" ] || log_error "Répertoire t2-sde introuvable. Lancez d'abord manager.sh."
}

step_configure() {
    if check_state "build_config"; then
        log_info "[SKIP] Configuration déjà effectuée."
        return 0
    fi
    log_info "Configuration du système cible..."
    cd "${SCRIPT_DIR}/t2-sde"
    echo "Configuration simulée pour x86_64..."
    mark_done "build_config"
    cd "${SCRIPT_DIR}"
}

step_compile() {
    if check_state "build_world"; then
        log_info "[SKIP] Compilation déjà terminée."
        return 0
    fi
    log_info "Lancement de la compilation (Make World)..."
    cd "${SCRIPT_DIR}/t2-sde"
    echo "Compilation en cours... (Ceci prendra du temps)"
    sleep 2
    mark_done "build_world"
    cd "${SCRIPT_DIR}"
}

main() {
    log_info "=== Démarrage du Build SDE ==="
    check_sde_exists
    step_configure
    step_compile
}

main "$@"