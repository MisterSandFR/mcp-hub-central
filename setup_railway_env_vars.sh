#!/bin/bash

# Guide de configuration des variables d'environnement Railway
# Usage: ./setup_railway_env_vars.sh

echo "🔧 Configuration des variables d'environnement Railway"

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

print_status "=== CONFIGURATION DES VARIABLES D'ENVIRONNEMENT RAILWAY ==="

echo ""
print_status "=== 1. VARIABLES OBLIGATOIRES ==="

print_status "Variables essentielles pour le Hub Central:"

print_status "🔧 PORT"
print_status "   Valeur: 8080"
print_status "   Description: Port sur lequel le hub central écoute"
print_status "   Railway: PORT=8080"

print_status "🔧 PYTHONUNBUFFERED"
print_status "   Valeur: 1"
print_status "   Description: Désactive le buffering Python pour les logs"
print_status "   Railway: PYTHONUNBUFFERED=1"

print_status "🔧 PYTHONDONTWRITEBYTECODE"
print_status "   Valeur: 1"
print_status "   Description: Empêche la création de fichiers .pyc"
print_status "   Railway: PYTHONDONTWRITEBYTECODE=1"

echo ""
print_status "=== 2. VARIABLES DE CONFIGURATION ==="

print_status "Variables de configuration du Hub:"

print_status "🔧 MCP_HUB_VERSION"
print_status "   Valeur: 3.6.0"
print_status "   Description: Version du hub central"
print_status "   Railway: MCP_HUB_VERSION=3.6.0"

print_status "🔧 MCP_HUB_NAME"
print_status "   Valeur: MCP Hub Central"
print_status "   Description: Nom du hub central"
print_status "   Railway: MCP_HUB_NAME=\"MCP Hub Central\""

print_status "🔧 MCP_HUB_DESCRIPTION"
print_status "   Valeur: Multi-server MCP hub for centralized management"
print_status "   Description: Description du hub central"
print_status "   Railway: MCP_HUB_DESCRIPTION=\"Multi-server MCP hub for centralized management\""

echo ""
print_status "=== 3. VARIABLES DE DÉCOUVERTE ==="

print_status "Variables pour la découverte des serveurs:"

print_status "🔧 SUPABASE_DISCOVERY_TIMEOUT"
print_status "   Valeur: 15"
print_status "   Description: Timeout de découverte pour Supabase (secondes)"
print_status "   Railway: SUPABASE_DISCOVERY_TIMEOUT=15"

print_status "🔧 MINECRAFT_DISCOVERY_TIMEOUT"
print_status "   Valeur: 5"
print_status "   Description: Timeout de découverte pour Minecraft (secondes)"
print_status "   Railway: MINECRAFT_DISCOVERY_TIMEOUT=5"

print_status "🔧 DISCOVERY_PATH"
print_status "   Valeur: /health"
print_status "   Description: Chemin de découverte par défaut"
print_status "   Railway: DISCOVERY_PATH=/health"

echo ""
print_status "=== 4. VARIABLES SUPABASE ==="

print_status "Variables pour la connexion Supabase:"

print_status "🔧 SUPABASE_URL"
print_status "   Valeur: https://api.recube.gg/"
print_status "   Description: URL de l'instance Supabase"
print_status "   Railway: SUPABASE_URL=https://api.recube.gg/"

print_status "🔧 SUPABASE_ANON_KEY"
print_status "   Valeur: eyJhbGciOiJIUzI1NiIs..."
print_status "   Description: Clé anonyme Supabase"
print_status "   Railway: SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs..."

print_status "🔧 SUPABASE_SERVICE_ROLE_KEY"
print_status "   Valeur: [VOTRE_SERVICE_ROLE_KEY]"
print_status "   Description: Clé de service role Supabase"
print_status "   Railway: SUPABASE_SERVICE_ROLE_KEY=[VOTRE_SERVICE_ROLE_KEY]"

print_status "🔧 SUPABASE_AUTH_JWT_SECRET"
print_status "   Valeur: [VOTRE_JWT_SECRET]"
print_status "   Description: Secret JWT pour l'authentification"
print_status "   Railway: SUPABASE_AUTH_JWT_SECRET=[VOTRE_JWT_SECRET]"

echo ""
print_status "=== 5. VARIABLES MINECRAFT ==="

print_status "Variables pour la connexion Minecraft:"

print_status "🔧 MINECRAFT_MCP_URL"
print_status "   Valeur: https://minecraft.mcp.coupaul.fr"
print_status "   Description: URL du serveur Minecraft MCP"
print_status "   Railway: MINECRAFT_MCP_URL=https://minecraft.mcp.coupaul.fr"

print_status "🔧 MINECRAFT_MCPC_VERSION"
print_status "   Valeur: 1.6.4"
print_status "   Description: Version MCPC+ Minecraft"
print_status "   Railway: MINECRAFT_MCPC_VERSION=1.6.4"

echo ""
print_status "=== 6. VARIABLES DE MONITORING ==="

print_status "Variables pour le monitoring:"

print_status "🔧 HEALTH_CHECK_INTERVAL"
print_status "   Valeur: 120"
print_status "   Description: Intervalle de vérification de santé (secondes)"
print_status "   Railway: HEALTH_CHECK_INTERVAL=120"

print_status "🔧 CACHE_DURATION"
print_status "   Valeur: 300"
print_status "   Description: Durée du cache (secondes)"
print_status "   Railway: CACHE_DURATION=300"

print_status "🔧 LOG_LEVEL"
print_status "   Valeur: INFO"
print_status "   Description: Niveau de log (DEBUG, INFO, WARNING, ERROR)"
print_status "   Railway: LOG_LEVEL=INFO"

echo ""
print_status "=== 7. CONFIGURATION RAILWAY ==="

print_status "Comment configurer les variables sur Railway:"

print_status "1. 🎯 Aller sur Railway Dashboard:"
print_status "   https://railway.app/dashboard"

print_status "2. 🔧 Sélectionner le projet MCP Hub Central:"
print_status "   - Cliquer sur le projet"
print_status "   - Aller dans l'onglet 'Variables'"

print_status "3. ⚙️ Ajouter les variables:"
print_status "   - Cliquer sur 'New Variable'"
print_status "   - Ajouter chaque variable avec sa valeur"
print_status "   - Sauvegarder"

print_status "4. 🚀 Redéployer:"
print_status "   - Cliquer sur 'Deploy' ou 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

echo ""
print_status "=== 8. COMMANDES DE TEST ==="

print_status "Tester après configuration:"
print_status "curl -s 'https://mcp.coupaul.fr/' | grep -i 'version'"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id: .id, status: .status}'"

print_status "Vérifier les variables:"
print_status "curl -s 'https://mcp.coupaul.fr/api/hub' | jq '.environment'"

echo ""
print_status "=== 9. RÉSUMÉ ==="

print_status "Variables essentielles à configurer:"

print_success "✅ PORT=8080"
print_success "✅ PYTHONUNBUFFERED=1"
print_success "✅ PYTHONDONTWRITEBYTECODE=1"
print_success "✅ MCP_HUB_VERSION=3.6.0"
print_success "✅ SUPABASE_DISCOVERY_TIMEOUT=15"
print_success "✅ MINECRAFT_DISCOVERY_TIMEOUT=5"
print_success "✅ SUPABASE_URL=https://api.recube.gg/"
print_success "✅ SUPABASE_ANON_KEY=[VOTRE_CLE]"
print_success "✅ MINECRAFT_MCP_URL=https://minecraft.mcp.coupaul.fr"

print_status "Actions recommandées:"
print_status "1. Configurer toutes les variables sur Railway"
print_status "2. Redéployer le projet"
print_status "3. Tester la découverte des serveurs"
print_status "4. Vérifier que les deux serveurs sont ONLINE"

echo ""
print_success "🚀 CONCLUSION: Configuration des variables d'environnement Railway"
print_status "✅ SOLUTION: Configurer les variables et redéployer"

exit 0
