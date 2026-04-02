# 📘 T2 Linux Workbench Laboratory

> **Projet :** [valorisa/T2-Linux-Workbench-Laboratory](https://github.com/valorisa/t2-linux-workbench-laboratory)  
> **Statut :** En développement actif | **Cible :** x86_64 / Multi-arch  
> **Environnement :** Linux (Debian/WSL) | **Shell :** Bash 5+  
> **OS Hôte :** Windows 11 Enterprise + PowerShell 7.6

Ce dépôt est conçu comme un environnement de travail reproductible pour **T2 Linux**. Il couvre deux objectifs distincts : l'installation de la distribution (via ISO) et la mise en place de l'environnement de développement (SDE) pour la compilation de binaires.

## 🎯 Objectifs du Projet

| Mode | Description | Méthode |
|------|-------------|---------|
| **Distro (ISO)** | Installer T2 Linux sur une machine cible | Documentation manuelle |
| **Kit de Build (SDE)** | Compiler ses propres binaires/images | Scripts automatisés |

---

## 🅰️ Installation T2/Linux (Mode ISO Classique)

Cette procédure documente l'installation manuelle sur le matériel cible.

### 🛠️ Prérequis

- Une clé USB bootable (min 2 Go)
- Le fichier ISO de la dernière version de T2 Linux
- Connexion Internet pour les mises à jour post-installation

### 📝 Procédure d'Installation

1. **Vérification de l'ISO :**
   ```bash
   sha256sum t2-linux-*.iso
   # Comparer avec le hash officiel sur t2linux.com
   ```

2. **Création du support bootable :**
   ```bash
   # Sous Linux/WSL
   sudo dd if=t2-linux.iso of=/dev/sdX bs=4M status=progress && sync
   ```

3. **Démarrage et Partitionnement :**
   - Bootez sur la clé USB
   - L'installateur texte `t2-config` se lance automatiquement
   - Configurez le réseau (DHCP ou IP statique)
   - Sélectionnez le schéma de partitionnement (GPT recommandé)

4. **Post-Installation :**
   - Mise à jour des paquets : `t2-update`
   - Configuration des utilisateurs : `t2-useradd`

---

## 🅱️ Installation T2 SDE (Kit de Build)

Cette section utilise les scripts fournis pour automatiser la création de l'environnement de compilation.

### 🚀 Démarrage Rapide

```bash
# Cloner le dépôt
git clone https://github.com/valorisa/t2-linux-workbench-laboratory.git
cd t2-linux-workbench-laboratory

# Lancer le gestionnaire (nécessite sudo)
sudo bash scripts/manager.sh

# Lancer la compilation
bash scripts/build_sde.sh
```

### ⚙️ Scripts Disponibles

| Script | Rôle | Idempotent |
|--------|------|------------|
| `scripts/manager.sh` | Installation dépendances + init SDE | ✅ Oui |
| `scripts/build_sde.sh` | Configuration + compilation cible | ✅ Oui |

### 🔧 Variables d'Environnement

| Variable | Défaut | Description |
|----------|--------|-------------|
| `TARGET_ARCH` | `x86_64` | Architecture cible (x86_64, arm64, etc.) |
| `T2_SDE_VERSION` | `2025.03` | Version du SDE à utiliser |
| `STATE_DIR` | `./.t2_state` | Répertoire de suivi d'état |

### 🔄 Idempotence

Les scripts utilisent un système de **fichiers d'état** (`.t2_state/`). Si une étape est déjà complétée, elle est ignorée :

```bash
# Pour forcer la ré-exécution d'une étape
rm .t2_state/deps.done
sudo bash scripts/manager.sh

# Ou utiliser le flag --force (si implémenté)
sudo bash scripts/manager.sh --force
```

---

## 🛠️ Dépannage

| Problème | Solution |
|----------|----------|
| Échec `apt-get` | `sudo apt-get update && sudo apt-get dist-upgrade` |
| Git clone échoue | Vérifier `git config --global http.sslVerify false` (proxy) |
| Build échoue | Nettoyer : `rm -rf .t2_state && bash scripts/build_sde.sh` |

---

## 📎 Liens Officiels & Références

- [Site officiel T2 Linux](https://t2linux.com/)
- [Dernières Nouvelles T2 (News 2026)](https://t2linux.com/#news-2026-03-04)
- [Wiki du Projet](https://github.com/valorisa/t2-linux-workbench-laboratory/wiki)
- [Dépôt GitHub](https://github.com/valorisa/t2-linux-workbench-laboratory)

---

## 📄 Licence

Ce projet est distribué sous licence MIT. Voir `LICENSE` pour plus de détails.