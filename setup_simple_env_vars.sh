#!/bin/bash

# Script de configuration simple des variables d'environnement Railway
# Usage: ./setup_simple_env_vars.sh

echo "🔧 Configuration simple des variables d'environnement Railway"

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

print_status "=== CONFIGURATION SIMPLE DES VARIABLES D'ENVIRONNEMENT ==="

echo ""
print_status "=== 1. VARIABLES ESSENTIELLES ==="

print_status "Variables obligatoires à configurer sur Railway:"

print_success "✅ PORT=8080"
print_status "   Description: Port du hub central"

print_success "✅ SUPABASE_MCP_URL=https://supabase.mcp.coupaul.fr"
print_status "   Description: URL du serveur Supabase MCP"

print_success "✅ MINECRAFT_MCP_URL=https://minecraft.mcp.coupaul.fr"
print_status "   Description: URL du serveur Minecraft MCP"

print_success "✅ MCP_HUB_VERSION=3.7.0"
print_status "   Description: Version du hub central"

print_success "✅ MCP_HUB_NAME=\"MCP Hub Central\""
print_status "   Description: Nom du hub central"

print_success "✅ MCP_HUB_DESCRIPTION=\"Multi-server MCP hub - Configuration simple\""
print_status "   Description: Description du hub central"

echo ""
print_status "=== 2. VARIABLES SUPABASE (OPTIONNELLES) ==="

print_status "Variables Supabase (si vous voulez les configurer):"

print_warning "⚠️ SUPABASE_URL=https://api.recube.gg/"
print_status "   Description: URL de l'instance Supabase"

print_warning "⚠️ SUPABASE_ANON_KEY=[VOTRE_CLE]"
print_status "   Description: Clé anonyme Supabase"

print_warning "⚠️ SUPABASE_SERVICE_ROLE_KEY=[VOTRE_SERVICE_ROLE_KEY]"
print_status "   Description: Clé de service role Supabase"

print_warning "⚠️ SUPABASE_AUTH_JWT_SECRET=[VOTRE_JWT_SECRET]"
print_status "   Description: Secret JWT pour l'authentification"

echo ""
print_status "=== 3. VARIABLES MINECRAFT (OPTIONNELLES) ==="

print_status "Variables Minecraft (si vous voulez les configurer):"

print_warning "⚠️ MINECRAFT_MCPC_VERSION=1.6.4"
print_status "   Description: Version MCPC+ Minecraft"

echo ""
print_status "=== 4. CONFIGURATION RAILWAY ==="

print_status "Comment configurer sur Railway:"

print_status "1. 🎯 Aller sur Railway Dashboard:"
print_status "   https://railway.app/dashboard"

print_status "2. 🔧 Sélectionner le projet MCP Hub Central:"
print_status "   - Cliquer sur le projet"
print_status "   - Aller dans l'onglet 'Variables'"

print_status "3. ⚙️ Ajouter les variables essentielles:"
print_status "   - PORT=8080"
print_status "   - SUPABASE_MCP_URL=https://supabase.mcp.coupaul.fr"
print_status "   - MINECRAFT_MCP_URL=https://minecraft.mcp.coupaul.fr"
print_status "   - MCP_HUB_VERSION=3.7.0"
print_status "   - MCP_HUB_NAME=\"MCP Hub Central\""
print_status "   - MCP_HUB_DESCRIPTION=\"Multi-server MCP hub - Configuration simple\""

print_status "4. 🚀 Redéployer:"
print_status "   - Cliquer sur 'Deploy' ou 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

echo ""
print_status "=== 5. RÉSULTAT ATTENDU ==="

print_status "Après configuration et redéploiement:"

print_success "✅ Serveur Supabase: ONLINE"
print_status "   - URL: https://supabase.mcp.coupaul.fr"
print_status "   - Outils: 54 outils disponibles"

print_success "✅ Serveur Minecraft: ONLINE"
print_status "   - URL: https://minecraft.mcp.coupaul.fr"
print_status "   - Outils: 2 outils disponibles"

print_success "✅ Hub Central: Version 3.7.0"
print_status "   - Affiche: \"Serving 2 MCP servers with 56 tools\""
print_status "   - Pas de découverte automatique"
print_status "   - Configuration simple et fiable"

echo ""
print_status "=== 6. COMMANDES DE TEST ==="

print_status "Tester après configuration:"
print_status "curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "Vérifier les URLs:"
print_status "curl -s 'https://supabase.mcp.coupaul.fr/health'"
print_status "curl -s 'https://minecraft.mcp.coupaul.fr/health'"

echo ""
print_status "=== 7. RÉSUMÉ ==="

print_status "Configuration simplifiée:"

print_success "✅ PAS DE DÉCOUVERTE AUTOMATIQUE"
print_success "✅ CONFIGURATION DIRECTE DES URLs"
print_success "✅ VARIABLES D'ENVIRONNEMENT SIMPLES"
print_success "✅ SERVEURS TOUJOURS ONLINE"
print_success "✅ CONFIGURATION FIABLE ET RAPIDE"

print_status "Actions recommandées:"
print_status "1. Configurer les 6 variables essentielles sur Railway"
print_status "2. Redéployer le projet"
print_status "3. Tester que les deux serveurs sont ONLINE"
print_status "4. Profiter d'une configuration simple et fiable !"

echo ""
print_success "🚀 CONCLUSION: Configuration simple et efficace"
print_status "✅ SOLUTION: URLs directes dans les variables d'environnement"

exit 0
