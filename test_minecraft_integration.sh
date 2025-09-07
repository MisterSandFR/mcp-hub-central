#!/bin/bash

# Script de test d'intégration pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./test_minecraft_integration.sh

echo "🎮 Test d'intégration du serveur Minecraft MCPC+ 1.6.4 avec le hub central"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[TEST]${NC} $1"
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

MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
HUB_URL="https://mcp.coupaul.fr"

print_status "=== TEST D'INTÉGRATION MINECRAFT MCPC+ 1.6.4 ==="
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Hub Central: $HUB_URL"

echo ""
print_status "=== 1. TEST DU SERVEUR MINECRAFT ==="

# Test du health check
print_status "Test du health check..."
health_response=$(curl -s --connect-timeout 10 "$MINECRAFT_URL/health" 2>/dev/null)
if echo "$health_response" | grep -q '"status":"healthy"'; then
    print_success "Health check: OK"
    echo "Réponse: $health_response"
else
    print_error "Health check: ÉCHEC"
    echo "Réponse: $health_response"
fi

# Test de l'API des outils
print_status "Test de l'API des outils..."
tools_response=$(curl -s --connect-timeout 10 "$MINECRAFT_URL/api/tools" 2>/dev/null)
if echo "$tools_response" | grep -q '"success":true'; then
    print_success "API des outils: OK"
    tools_count=$(echo "$tools_response" | grep -o '"name":' | wc -l)
    print_status "Nombre d'outils détectés: $tools_count"
else
    print_error "API des outils: ÉCHEC"
fi

# Test de la configuration MCP
print_status "Test de la configuration MCP..."
config_response=$(curl -s --connect-timeout 10 "$MINECRAFT_URL/.well-known/mcp-config" 2>/dev/null)
if echo "$config_response" | grep -q '"name":"mcp-minecraft-mcpc-1.6.4"'; then
    print_success "Configuration MCP: OK"
    echo "Nom du serveur: $(echo "$config_response" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)"
    echo "Version: $(echo "$config_response" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)"
else
    print_error "Configuration MCP: ÉCHEC"
fi

echo ""
print_status "=== 2. TEST DU HUB CENTRAL ==="

# Test de la détection des serveurs
print_status "Test de la détection des serveurs..."
servers_response=$(curl -s --connect-timeout 10 "$HUB_URL/api/servers" 2>/dev/null)
if echo "$servers_response" | grep -q '"name"'; then
    print_success "API des serveurs: OK"
    servers_count=$(echo "$servers_response" | grep -o '"name":' | wc -l)
    print_status "Nombre de serveurs détectés: $servers_count"
    
    # Vérifier si Minecraft est détecté
    if echo "$servers_response" | grep -q "minecraft\|Minecraft\|MCPC"; then
        print_success "Serveur Minecraft détecté par le hub central"
    else
        print_warning "Serveur Minecraft NON détecté par le hub central"
        print_status "Serveurs détectés:"
        echo "$servers_response" | grep -o '"name":"[^"]*"' | cut -d'"' -f4
    fi
else
    print_error "API des serveurs: ÉCHEC"
fi

# Test de la liste des outils
print_status "Test de la liste des outils..."
tools_hub_response=$(curl -s --connect-timeout 10 "$HUB_URL/api/tools" 2>/dev/null)
if echo "$tools_hub_response" | grep -q '"name"'; then
    print_success "API des outils du hub: OK"
    tools_hub_count=$(echo "$tools_hub_response" | grep -o '"name":' | wc -l)
    print_status "Nombre total d'outils dans le hub: $tools_hub_count"
    
    # Vérifier si les outils Minecraft sont présents
    if echo "$tools_hub_response" | grep -q "minecraft\|Minecraft\|MCPC\|analyze_gui_spritesheet"; then
        print_success "Outils Minecraft détectés dans le hub central"
    else
        print_warning "Outils Minecraft NON détectés dans le hub central"
    fi
else
    print_error "API des outils du hub: ÉCHEC"
fi

echo ""
print_status "=== 3. RÉSUMÉ DE L'INTÉGRATION ==="

# Vérifier l'état global
minecraft_working=false
hub_detecting_minecraft=false

if echo "$health_response" | grep -q '"status":"healthy"'; then
    minecraft_working=true
fi

if echo "$servers_response" | grep -q "minecraft\|Minecraft\|MCPC"; then
    hub_detecting_minecraft=true
fi

if [ "$minecraft_working" = true ] && [ "$hub_detecting_minecraft" = true ]; then
    print_success "🎉 INTÉGRATION COMPLÈTE RÉUSSIE !"
    print_success "✅ Serveur Minecraft MCPC+ 1.6.4 opérationnel"
    print_success "✅ Hub central détecte le serveur Minecraft"
    print_success "✅ Outils Minecraft disponibles dans le hub"
    
elif [ "$minecraft_working" = true ] && [ "$hub_detecting_minecraft" = false ]; then
    print_warning "⚠️ SERVEUR OPÉRATIONNEL MAIS NON DÉTECTÉ"
    print_success "✅ Serveur Minecraft MCPC+ 1.6.4 opérationnel"
    print_warning "⚠️ Hub central ne détecte pas le serveur Minecraft"
    print_status "Action requise: Mettre à jour la configuration du hub central"
    
elif [ "$minecraft_working" = false ]; then
    print_error "❌ SERVEUR NON OPÉRATIONNEL"
    print_error "❌ Serveur Minecraft MCPC+ 1.6.4 non accessible"
    print_status "Action requise: Vérifier le déploiement Railway"
fi

echo ""
print_status "=== 4. ACTIONS RECOMMANDÉES ==="

if [ "$minecraft_working" = true ] && [ "$hub_detecting_minecraft" = false ]; then
    print_status "Pour intégrer le serveur Minecraft au hub central:"
    print_status "1. Vérifier la configuration du hub central"
    print_status "2. Forcer la découverte des serveurs"
    print_status "3. Redémarrer le hub central si nécessaire"
    print_status "4. Vérifier que la configuration inclut le serveur Minecraft"
fi

echo ""
print_status "=== 5. COMMANDES UTILES ==="
print_status "Test manuel du serveur: curl -s $MINECRAFT_URL/health"
print_status "Test manuel du hub: curl -s $HUB_URL/api/servers"
print_status "Interface Minecraft: $MINECRAFT_URL"
print_status "Hub central: $HUB_URL"

exit 0
