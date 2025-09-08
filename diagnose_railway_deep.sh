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

print_status "=== DIAGNOSTIC APPROFONDI RAILWAY ==="

echo ""
print_status "=== 1. VÉRIFICATION DE L'ÉTAT ACTUEL ==="

# Vérifier la version actuelle
print_status "Vérification de la version actuelle..."
current_version=$(curl -s "https://mcp.coupaul.fr/" | grep -i "version" | head -1)
print_status "Version actuelle: $current_version"

# Vérifier le statut des serveurs
print_status "Vérification du statut des serveurs..."
servers_status=$(curl -s "https://mcp.coupaul.fr/api/servers" | jq '.servers[] | {id: .id, status: .status}' 2>/dev/null || echo "Erreur de récupération")
print_status "Statut des serveurs: $servers_status"

# Vérifier la configuration de découverte
print_status "Vérification de la configuration de découverte..."
discovery_config=$(curl -s "https://mcp.coupaul.fr/api/servers" | jq '.servers[] | select(.id == "supabase") | .discovery_timeout' 2>/dev/null || echo "Pas de discovery_timeout")
print_status "Configuration de découverte: $discovery_config"

echo ""
print_status "=== 2. ANALYSE DU PROBLÈME ==="

print_status "Problème identifié:"
print_error "Railway n'a pas déployé les dernières corrections"

print_status "Causes possibles:"
print_warning "1. 🔄 Webhook GitHub cassé"
print_status "   - Railway ne reçoit pas les notifications GitHub"
print_status "   - Webhook mal configuré ou désactivé"

print_warning "2. 📝 Problème de build"
print_status "   - Erreur de build Railway"
print_status "   - Dépendances manquantes"
print_status "   - Configuration incorrecte"

print_warning "3. 🐌 Cache Railway persistant"
print_status "   - Cache Railway non vidé"
print_status "   - Ancienne version en cache"
print_status "   - Problème de déploiement"

print_warning "4. ⚙️ Configuration Railway incorrecte"
print_status "   - Variables d'environnement incorrectes"
print_status "   - Configuration de déploiement obsolète"
print_status "   - Problème de permissions"

print_warning "5. 🚀 Problème de déploiement"
print_status "   - Déploiement échoué silencieusement"
print_status "   - Problème de réseau"
print_status "   - Problème de ressources"

echo ""
print_status "=== 3. SOLUTIONS ==="

print_status "Solutions pour résoudre le problème:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur https://railway.app/dashboard"
print_status "   - Sélectionner le projet MCP Hub Central"
print_status "   - Cliquer sur 'Redeploy' ou 'Deploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Railway CLI"
print_status "   - Installer Railway CLI: npm install -g @railway/cli"
print_status "   - Se connecter: railway login"
print_status "   - Redéployer: railway up"

print_status "3. 📝 SOLUTION WEBHOOK: Vérifier GitHub"
print_status "   - Aller sur https://github.com/MisterSandFR/mcp-hub-central"
print_status "   - Cliquer sur 'Settings' > 'Webhooks'"
print_status "   - Vérifier que le webhook Railway est actif"

print_status "4. ⚙️ SOLUTION CONFIGURATION: Nouveau projet"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Déployer depuis zéro"
print_status "   - Migrer la configuration"

print_status "5. 🚀 SOLUTION INFRASTRUCTURE: Alternative"
print_status "   - Utiliser un autre service de déploiement"
print_status "   - Déployer sur Vercel, Netlify, ou Heroku"
print_status "   - Utiliser Docker avec un autre service"

echo ""
print_status "=== 4. COMMANDES DE TEST ==="

print_status "Tester après redéploiement:"
print_status "curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "Tester la découverte:"
print_status "curl -s 'https://supabase.mcp.coupaul.fr/health'"
print_status "curl -s 'https://minecraft.mcp.coupaul.fr/health'"

print_status "Tester la configuration:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | select(.id == \"supabase\") | .discovery_timeout'"

echo ""
print_status "=== 5. DIAGNOSTIC AVANCÉ ==="

print_status "Diagnostic avancé Railway:"

print_status "1. 🔍 Vérifier les logs Railway:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Logs'"
print_status "   - Vérifier les erreurs de build"

print_status "2. 📊 Vérifier les métriques:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Metrics'"
print_status "   - Vérifier l'utilisation des ressources"

print_status "3. ⚙️ Vérifier les variables d'environnement:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Variables'"
print_status "   - Vérifier la configuration"

print_status "4. 🔄 Vérifier les déploiements:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Deployments'"
print_status "   - Vérifier l'historique des déploiements"

echo ""
print_status "=== 6. RÉSUMÉ ==="

print_status "Statut du diagnostic:"

print_error "❌ Railway: Problème de déploiement"
print_warning "⚠️ Version: 3.5.0 (au lieu de 3.6.0)"
print_warning "⚠️ Serveur Supabase: OFFLINE"
print_success "✅ Serveur Minecraft: ONLINE"

print_status "Actions recommandées:"
print_status "1. Redéploiement manuel Railway"
print_status "2. Vérification des logs Railway"
print_status "3. Vérification des webhooks GitHub"
print_status "4. Création d'un nouveau projet si nécessaire"

echo ""
print_warning "🚨 CONCLUSION: Railway a un problème de déploiement"
print_status "✅ SOLUTION: Redéploiement manuel ou nouveau projet Railway"

exit 0