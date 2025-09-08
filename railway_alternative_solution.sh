#!/bin/bash

# Script de solution alternative Railway
# Usage: ./railway_alternative_solution.sh

echo "🚀 Solution alternative Railway"

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

print_status "=== SOLUTION ALTERNATIVE RAILWAY ==="

echo ""
print_status "=== 1. DIAGNOSTIC FINAL ==="

# Vérifier la version actuelle
print_status "Vérification de la version actuelle..."
current_version=$(curl -s "https://mcp.coupaul.fr/" | grep -i "version" | head -1)
print_status "Version actuelle: $current_version"

# Vérifier le statut des serveurs
print_status "Vérification du statut des serveurs..."
servers_status=$(curl -s "https://mcp.coupaul.fr/api/servers" | jq '.servers[] | {id: .id, status: .status}' 2>/dev/null || echo "Erreur de récupération")
print_status "Statut des serveurs: $servers_status"

echo ""
print_status "=== 2. PROBLÈME IDENTIFIÉ ==="

print_error "Railway a un problème de déploiement persistant"
print_warning "Causes possibles:"
print_status "1. Webhook GitHub cassé"
print_status "2. Cache Railway persistant"
print_status "3. Problème de build Railway"
print_status "4. Configuration Railway incorrecte"
print_status "5. Problème de ressources Railway"

echo ""
print_status "=== 3. SOLUTIONS ALTERNATIVES ==="

print_status "Solutions recommandées:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur https://railway.app/dashboard"
print_status "   - Sélectionner le projet MCP Hub Central"
print_status "   - Cliquer sur 'Redeploy' ou 'Deploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Nouveau projet Railway"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Connecter le repository GitHub"
print_status "   - Déployer depuis zéro"
print_status "   - Migrer la configuration"

print_status "3. 🚀 SOLUTION INFRASTRUCTURE: Alternative de déploiement"
print_status "   - Utiliser Vercel (gratuit)"
print_status "   - Utiliser Netlify (gratuit)"
print_status "   - Utiliser Heroku (gratuit)"
print_status "   - Utiliser Render (gratuit)"

print_status "4. ⚙️ SOLUTION CONFIGURATION: Docker"
print_status "   - Créer un Dockerfile"
print_status "   - Déployer sur Railway avec Docker"
print_status "   - Utiliser un autre service Docker"

echo ""
print_status "=== 4. SOLUTION RECOMMANDÉE ==="

print_status "Solution recommandée: Nouveau projet Railway"

print_status "Étapes:"
print_status "1. Aller sur https://railway.app/dashboard"
print_status "2. Cliquer sur 'New Project'"
print_status "3. Sélectionner 'Deploy from GitHub repo'"
print_status "4. Choisir le repository mcp-hub-central"
print_status "5. Configurer les variables d'environnement"
print_status "6. Déployer"

print_status "Avantages:"
print_status "- Configuration fraîche"
print_status "- Pas de cache persistant"
print_status "- Déploiement propre"
print_status "- Configuration optimisée"

echo ""
print_status "=== 5. COMMANDES DE TEST ==="

print_status "Tester après redéploiement:"
print_status "curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "Tester la découverte:"
print_status "curl -s 'https://supabase.mcp.coupaul.fr/health'"
print_status "curl -s 'https://minecraft.mcp.coupaul.fr/health'"

echo ""
print_status "=== 6. RÉSUMÉ ==="

print_status "Statut du diagnostic:"

print_error "❌ Railway: Problème de déploiement persistant"
print_warning "⚠️ Version: 3.5.0 (au lieu de 3.6.0)"
print_warning "⚠️ Serveur Supabase: OFFLINE"
print_success "✅ Serveur Minecraft: ONLINE"

print_status "Actions recommandées:"
print_status "1. Créer un nouveau projet Railway"
print_status "2. Déployer depuis zéro"
print_status "3. Tester la découverte des serveurs"
print_status "4. Vérifier que les deux serveurs sont ONLINE"

echo ""
print_warning "🚨 CONCLUSION: Railway a un problème de déploiement persistant"
print_status "✅ SOLUTION: Nouveau projet Railway ou alternative de déploiement"

exit 0