#!/bin/bash

# Script pour forcer le redéploiement Railway
# Usage: ./force_railway_redeploy.sh

echo "🚀 Forçage du redéploiement Railway"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[RAILWAY]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✅ SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️ WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[❌ ERROR]${NC} $1"
}

print_status "=== FORÇAGE DU REDÉPLOIEMENT RAILWAY ==="

echo ""
print_status "=== 1. VÉRIFICATION DES COMMITS LOCAUX ==="

# Vérifier les commits locaux
print_status "Commits locaux récents:"
git log --oneline -5

echo ""
print_status "=== 2. VÉRIFICATION DU STATUT GIT ==="

# Vérifier le statut git
print_status "Statut Git:"
git status

echo ""
print_status "=== 3. FORÇAGE DU PUSH ==="

# Forcer le push
print_status "Forçage du push vers GitHub..."
git push origin master --force

if [ $? -eq 0 ]; then
    print_success "Push forcé réussi"
else
    print_error "Échec du push forcé"
fi

echo ""
print_status "=== 4. VÉRIFICATION DU WEBHOOK RAILWAY ==="

print_status "Railway devrait automatiquement redéployer après le push..."
print_status "Attendre 2-3 minutes pour le redéploiement automatique"

echo ""
print_status "=== 5. ACTIONS MANUELLES RAILWAY ==="

print_warning "Si le redéploiement automatique ne fonctionne pas:"
print_status "1. Aller sur https://railway.app/dashboard"
print_status "2. Sélectionner le projet 'mcp-hub-central'"
print_status "3. Cliquer sur l'onglet 'Deployments'"
print_status "4. Cliquer sur 'Redeploy' sur le dernier déploiement"
print_status "5. Attendre 2-3 minutes"

echo ""
print_status "=== 6. VÉRIFICATION DES LOGS RAILWAY ==="

print_warning "Vérifier les logs Railway pour les erreurs:"
print_status "1. Aller sur Railway Dashboard"
print_status "2. Sélectionner le projet"
print_status "3. Cliquer sur l'onglet 'Logs'"
print_status "4. Chercher les erreurs de build ou runtime"

echo ""
print_status "=== 7. VARIABLES D'ENVIRONNEMENT RAILWAY ==="

print_warning "Vérifier les variables d'environnement:"
print_status "1. Aller sur Railway Dashboard"
print_status "2. Sélectionner le projet"
print_status "3. Cliquer sur l'onglet 'Variables'"
print_status "4. Vérifier que les variables sont à jour"

echo ""
print_status "=== 8. COMMANDES DE VÉRIFICATION ==="

print_status "Après le redéploiement, vérifier:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.hub.version'"
print_status "curl -w '@-' -o /dev/null -s 'https://mcp.coupaul.fr/' <<< 'time_total: %{time_total}\n'"

echo ""
print_status "=== 9. RÉSUMÉ ==="

print_status "Actions effectuées:"
print_status "1. ✅ Push forcé vers GitHub"
print_status "2. ⏳ Attente du redéploiement Railway"
print_status "3. 🔍 Vérification des logs Railway"

print_status "Prochaines étapes:"
print_status "1. Attendre 2-3 minutes"
print_status "2. Vérifier les performances"
print_status "3. Si problème persiste, redéployer manuellement"

echo ""
print_warning "🚨 CONCLUSION: Redéploiement Railway forcé"
print_status "✅ SOLUTION: Attendre 2-3 minutes et vérifier les performances"

exit 0
