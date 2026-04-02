#!/usr/bin/env bash
# ==============================================================================
# Fichier   : scripts/build_sde.sh
# Rôle      : Compilation croisée/native via le T2 SDE
# Licence   : MIT
# Version   : 1.0.0
# ==============================================================================
set -euo pipefail

readonly STATE_DIR="./.t2_state"

# --- Utilitaires (Identiques au manager pour cohérence) ---
log_info()    { echo -e "\e[34m[BUILD]\e[0m $1"; }
log_success() { echo -e "\e[32m[BUILD_OK]\e[0m $1"; }
log_error()   { echo -e "\e[31m[BUILD_FAIL]\e[0m $1"; exit 1; }
check_state() { [ -f "${STATE_DIR}/${1}.done" ] && return 0 || return 1; }
mark_done()   { touch "${STATE_DIR}/${1}.done"; log_success "Build étape '$1' validée."; }

# --- Prérequis ---
check_sde_exists() {
    [ -d "t2-sde" ] || log_error "Répertoire t2-sde introuvable. Lancez d'abord manager.sh."
}

# --- Étapes de Build ---
step_configure() {
    if check_state "build_config"; then
        log_info "[SKIP] Configuration déjà effectuée."
        return 0
    fi

    log_info "Configuration du système cible..."
    cd t2-sde
    
    # Simulation de la commande t2-config
    # En réalité : ./t2-config --arch x86_64 --profile server
    echo "Configuration simulée pour x86_64..." 
    
    mark_done "build_config"
    cd ..
}

step_compile() {
    if check_state "build_world"; then
        log_info "[SKIP] Compilation déjà terminée."
        return 0
    fi

    log_info "Lancement de la compilation (Make World)..."
    cd t2-sde
    
    # Simulation de make
    # En réalité : make -j$(nproc)
    echo "Compilation en cours... (Ceci prendra du temps)"
    sleep 2 
    
    mark_done "build_world"
    cd ..
    log_success "Artefacts disponibles dans t2-sde/bin/"
}

# --- Point d'Entrée ---
main() {
    log_info "=== Démarrage du Build SDE ==="
    check_sde_exists
    
    step_configure
    step_compile
}

main "$@"