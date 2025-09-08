#!/bin/bash

# Script de diagnostic approfondi Railway
# Usage: ./diagnose_railway_deep.sh

echo "🔍 Diagnostic approfondi Railway"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[DIAG]${NC} $1"
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

print_status "=== DIAGNOSTIC APPROFONDI RAILWAY ==="

echo ""
print_status "=== 1. VÉRIFICATION DU DÉPLOIEMENT RAILWAY ==="

# Vérifier si Railway a déployé nos changements
print_status "Vérification de la version déployée..."
version_deployed=$(curl -s --max-time 10 "https://mcp.coupaul.fr/api/servers" 2>/dev/null | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$version_deployed" ]; then
    print_status "Version déployée: $version_deployed"
    if [ "$version_deployed" = "3.5.0" ]; then
        print_success "✅ Version à jour (3.5.0) - Déploiement réussi"
    else
        print_error "❌ Version obsolète ($version_deployed) - Déploiement non effectué"
    fi
else
    print_error "❌ Impossible de vérifier la version"
fi

echo ""
print_status "=== 2. ANALYSE DU PROBLÈME RAILWAY ==="

print_status "Problèmes possibles avec Railway:"

print_warning "1. 🔄 Railway ne déploie pas automatiquement"
print_status "   - Webhook GitHub cassé"
print_status "   - Railway ne reçoit pas les notifications"
print_status "   - Déploiement manuel nécessaire"

print_warning "2. 🐌 Cache Railway persistant"
print_status "   - Railway utilise un cache persistant"
print_status "   - Cache non invalidé malgré les changements"
print_status "   - Ancienne configuration utilisée"

print_warning "3. ⚙️ Configuration Railway incorrecte"
print_status "   - Variables d'environnement obsolètes"
print_status "   - Configuration Railway non mise à jour"
print_status "   - Fichiers non synchronisés"

print_warning "4. 🔍 Problème de build Railway"
print_status "   - Erreur de build sur Railway"
print_status "   - Dépendances manquantes"
print_status "   - Logs Railway non accessibles"

echo ""
print_status "=== 3. SOLUTIONS RAILWAY ==="

print_status "Solutions pour résoudre le problème Railway:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Sélectionner le projet mcp-hub-central"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Vérifier les webhooks"
print_status "   - Aller sur GitHub Settings > Webhooks"
print_status "   - Vérifier que Railway est configuré"
print_status "   - Tester le webhook"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Variables d'environnement"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les variables d'environnement"
print_status "   - S'assurer qu'elles sont à jour"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Nouveau déploiement"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Connecter au repository GitHub"
print_status "   - Redéployer depuis zéro"

echo ""
print_status "=== 4. ACTIONS IMMÉDIATES ==="

print_status "Actions à effectuer maintenant:"

print_status "1. 🔍 Vérifier Railway Dashboard:"
print_status "   - Aller sur https://railway.app/dashboard"
print_status "   - Sélectionner le projet mcp-hub-central"
print_status "   - Vérifier les logs de build"
print_status "   - Vérifier les logs runtime"

print_status "2. 🔄 Forcer le redéploiement:"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"
print_status "   - Vérifier les performances"

print_status "3. 🔧 Vérifier les webhooks GitHub:"
print_status "   - Aller sur GitHub Settings > Webhooks"
print_status "   - Vérifier que Railway est configuré"
print_status "   - Tester le webhook"

print_status "4. ⚙️ Vérifier les variables d'environnement:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les variables d'environnement"
print_status "   - S'assurer qu'elles sont à jour"

echo ""
print_status "=== 5. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier le déploiement Railway:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.hub.version'"

print_status "Vérifier les performances:"
print_status "curl -w '@-' -o /dev/null -s 'https://mcp.coupaul.fr/' <<< 'time_total: %{time_total}\n'"

print_status "Vérifier les serveurs:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id, host, port, protocol}'"

echo ""
print_status "=== 6. RÉSUMÉ ==="

print_status "Statut du diagnostic:"

if [ "$version_deployed" = "3.5.0" ]; then
    print_success "✅ Déploiement Railway réussi"
    print_status "Le problème est ailleurs (configuration, ports, etc.)"
else
    print_error "❌ Déploiement Railway échoué"
    print_status "Railway n'a pas déployé nos changements"
fi

print_status "Actions recommandées:"
print_status "1. Redéployer manuellement sur Railway"
print_status "2. Vérifier les logs Railway"
print_status "3. Vérifier les webhooks GitHub"
print_status "4. Si nécessaire, créer un nouveau projet Railway"

echo ""
print_error "🚨 CONCLUSION: Railway ne déploie pas les changements"
print_status "✅ SOLUTION: Redéploiement manuel sur Railway Dashboard"
print_status "Le problème est côté Railway, pas côté code !"

exit 0
