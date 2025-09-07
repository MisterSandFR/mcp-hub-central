#!/bin/bash

# Script de diagnostic pour le hub central local
# Usage: ./diagnose_local_hub.sh

echo "🔍 Diagnostic du hub central local sur le port 8080"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[DIAGNOSTIC]${NC} $1"
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

HUB_URL="http://localhost:8080"
SUPABASE_URL="http://localhost:8001"
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"

print_status "=== DIAGNOSTIC HUB CENTRAL LOCAL ==="
print_status "Hub Central: $HUB_URL"
print_status "Supabase Local: $SUPABASE_URL"
print_status "Minecraft Remote: $MINECRAFT_URL"

echo ""
print_status "=== 1. TEST DU HUB CENTRAL LOCAL ==="

# Test de connectivité du hub
print_status "Test de connectivité du hub central..."
if curl -s --connect-timeout 5 "$HUB_URL/health" > /dev/null 2>&1; then
    print_success "Hub central accessible"
    health_response=$(curl -s --connect-timeout 5 "$HUB_URL/health" 2>/dev/null)
    echo "Réponse: $health_response"
else
    print_error "Hub central non accessible"
    print_status "Vérifiez que le hub central est démarré sur le port 8080"
fi

# Test de l'API des serveurs
print_status "Test de l'API des serveurs..."
if curl -s --connect-timeout 5 "$HUB_URL/api/servers" > /dev/null 2>&1; then
    print_success "API des serveurs accessible"
    servers_response=$(curl -s --connect-timeout 5 "$HUB_URL/api/servers" 2>/dev/null)
    echo "Serveurs détectés: $servers_response"
else
    print_error "API des serveurs non accessible"
fi

echo ""
print_status "=== 2. TEST DES SERVEURS MCP ==="

# Test du serveur Supabase local
print_status "Test du serveur Supabase local..."
if curl -s --connect-timeout 5 "$SUPABASE_URL/health" > /dev/null 2>&1; then
    print_success "Serveur Supabase local accessible"
else
    print_error "Serveur Supabase local non accessible (Connection refused)"
    print_status "Le serveur Supabase local n'est pas démarré sur le port 8001"
fi

# Test du serveur Minecraft distant
print_status "Test du serveur Minecraft distant..."
if curl -s --connect-timeout 10 "$MINECRAFT_URL/health" > /dev/null 2>&1; then
    print_success "Serveur Minecraft distant accessible"
    minecraft_response=$(curl -s --connect-timeout 10 "$MINECRAFT_URL/health" 2>/dev/null)
    echo "Réponse: $minecraft_response"
else
    print_error "Serveur Minecraft distant non accessible (timeout)"
    print_status "Problème de connectivité avec le serveur distant"
fi

echo ""
print_status "=== 3. ANALYSE DES ERREURS ==="

print_status "Erreurs détectées:"
print_error "1. Server supabase configured but offline: Connection refused"
print_error "   → Le serveur Supabase local n'est pas démarré sur le port 8001"
print_error "2. Server minecraft discovery failed: timed out"
print_error "   → Problème de connectivité avec le serveur Minecraft distant"

echo ""
print_status "=== 4. SOLUTIONS RECOMMANDÉES ==="

print_status "Pour résoudre les problèmes:"

print_status "1. Démarrer le serveur Supabase local:"
print_status "   - Vérifier que Docker est démarré"
print_status "   - Exécuter: docker-compose up -d supabase-mcp-server"
print_status "   - Vérifier: curl http://localhost:8001/health"

print_status "2. Vérifier la connectivité Minecraft:"
print_status "   - Tester: curl https://minecraft.mcp.coupaul.fr/health"
print_status "   - Vérifier la configuration réseau"
print_status "   - Augmenter le timeout si nécessaire"

print_status "3. Configuration du hub central:"
print_status "   - Vérifier mcp_servers_config.json"
print_status "   - Ajuster les timeouts de découverte"
print_status "   - Vérifier les URLs des serveurs"

echo ""
print_status "=== 5. COMMANDES DE DEBUG ==="

print_status "Vérifier les processus:"
print_status "ps aux | grep python"
print_status "netstat -ano | findstr :8080"
print_status "netstat -ano | findstr :8001"

print_status "Tester les serveurs:"
print_status "curl http://localhost:8080/health"
print_status "curl http://localhost:8001/health"
print_status "curl https://minecraft.mcp.coupaul.fr/health"

print_status "Logs Docker:"
print_status "docker-compose logs supabase-mcp-server"

echo ""
print_status "=== 6. ACTIONS IMMÉDIATES ==="

print_warning "Actions requises pour résoudre les problèmes:"
print_status "1. Démarrer le serveur Supabase local"
print_status "2. Vérifier la connectivité Minecraft"
print_status "3. Redémarrer le hub central si nécessaire"

exit 1
