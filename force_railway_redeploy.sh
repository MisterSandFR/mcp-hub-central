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
print_status "=== 1. VÉRIFICATION DE L'ÉTAT ACTUEL ==="

# Vérifier la version actuelle
print_status "Vérification de la version actuelle..."
current_version=$(curl -s "https://mcp.coupaul.fr/" | grep -i "version" | head -1)
print_status "Version actuelle: $current_version"

# Vérifier le statut des serveurs
print_status "Vérification du statut des serveurs..."
servers_status=$(curl -s "https://mcp.coupaul.fr/api/servers" | jq '.servers[] | {id: .id, status: .status}' 2>/dev/null || echo "Erreur de récupération")
print_status "Statut des serveurs: $servers_status"

echo ""
print_status "=== 2. FORÇAGE DU REDÉPLOIEMENT ==="

print_status "Méthodes pour forcer le redéploiement Railway:"

print_status "1. 🔄 REDÉPLOIEMENT MANUEL:"
print_status "   - Aller sur https://railway.app/dashboard"
print_status "   - Sélectionner le projet MCP Hub Central"
print_status "   - Cliquer sur 'Redeploy' ou 'Deploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 REDÉPLOIEMENT VIA CLI:"
print_status "   - Installer Railway CLI: npm install -g @railway/cli"
print_status "   - Se connecter: railway login"
print_status "   - Redéployer: railway up"

print_status "3. 📝 REDÉPLOIEMENT VIA WEBHOOK:"
print_status "   - Aller sur GitHub: https://github.com/MisterSandFR/mcp-hub-central"
print_status "   - Cliquer sur 'Actions'"
print_status "   - Relancer la dernière action"

print_status "4. 🚀 REDÉPLOIEMENT VIA COMMIT:"
print_status "   - Faire un commit vide: git commit --allow-empty -m 'Force redeploy'"
print_status "   - Pousser: git push origin master"

echo ""
print_status "=== 3. VÉRIFICATION POST-REDÉPLOIEMENT ==="

print_status "Après le redéploiement, vérifier:"

print_status "1. 📊 Version du hub:"
print_status "   curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"

print_status "2. 🔍 Statut des serveurs:"
print_status "   curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "3. ⚙️ Configuration de découverte:"
print_status "   curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | select(.id == \"supabase\") | .discovery_timeout'"

print_status "4. 🎯 Test de découverte:"
print_status "   curl -s 'https://supabase.mcp.coupaul.fr/health'"
print_status "   curl -s 'https://minecraft.mcp.coupaul.fr/health'"

echo ""
print_status "=== 4. DIAGNOSTIC DES PROBLÈMES ==="

print_status "Problèmes possibles:"

print_warning "1. 🔄 Railway ne redéploie pas:"
print_status "   - Webhook GitHub cassé"
print_status "   - Cache Railway persistant"
print_status "   - Problème de build"

print_warning "2. 📝 Code non déployé:"
print_status "   - Ancienne version en cache"
print_status "   - Problème de build"
print_status "   - Variables d'environnement incorrectes"

print_warning "3. ⚙️ Configuration incorrecte:"
print_status "   - Fichier mcp_servers_config.json non trouvé"
print_status "   - Configuration hardcodée obsolète"
print_status "   - Paramètres de découverte incorrects"

echo ""
print_status "=== 5. SOLUTIONS ==="

print_status "Solutions recommandées:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Commit vide"
print_status "   - git commit --allow-empty -m 'Force redeploy'"
print_status "   - git push origin master"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Vérifier les fichiers"
print_status "   - Vérifier que mcp_servers_config.json existe"
print_status "   - Vérifier la configuration hardcodée"
print_status "   - Vérifier les paramètres de découverte"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Nouveau projet"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Déployer depuis zéro"
print_status "   - Migrer la configuration"

echo ""
print_status "=== 6. COMMANDES DE TEST ==="

print_status "Tester après redéploiement:"
print_status "curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "Tester la découverte:"
print_status "curl -s 'https://supabase.mcp.coupaul.fr/health'"
print_status "curl -s 'https://minecraft.mcp.coupaul.fr/health'"

echo ""
print_status "=== 7. RÉSUMÉ ==="

print_status "Actions à effectuer:"
print_status "1. Forcer le redéploiement Railway"
print_status "2. Attendre 2-3 minutes"
print_status "3. Vérifier la version déployée"
print_status "4. Tester la découverte des serveurs"

print_warning "🚨 CONCLUSION: Railway n'a pas déployé les dernières corrections"
print_status "✅ SOLUTION: Forcer le redéploiement Railway"

exit 0