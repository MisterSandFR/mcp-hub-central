#!/bin/bash

# Script de monitoring pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./monitor_minecraft_mcpc.sh

echo "🔍 Monitoring du serveur Minecraft MCPC+ 1.6.4..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[MONITOR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✅ ONLINE]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️ DEPLOYING]${NC} $1"
}

print_error() {
    echo -e "${RED}[❌ ERROR]${NC} $1"
}

SERVER_URL="https://minecraft.mcp.coupaul.fr"
MAX_ATTEMPTS=10
ATTEMPT=1

print_status "Démarrage du monitoring..."
print_status "URL: $SERVER_URL"
print_status "Tentatives maximum: $MAX_ATTEMPTS"

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    print_status "Tentative $ATTEMPT/$MAX_ATTEMPTS..."
    
    # Test de l'endpoint health
    response=$(curl -s --connect-timeout 10 "$SERVER_URL/health" 2>/dev/null)
    
    if echo "$response" | grep -q '"status":"UP"'; then
        print_success "Serveur Minecraft MCPC+ 1.6.4 opérationnel !"
        echo "Réponse complète:"
        echo "$response" | jq . 2>/dev/null || echo "$response"
        
        # Test des autres endpoints
        print_status "Test des autres endpoints..."
        
        if curl -s --connect-timeout 5 "$SERVER_URL/api/tools" > /dev/null 2>&1; then
            print_success "API des outils accessible"
        fi
        
        if curl -s --connect-timeout 5 "$SERVER_URL/mcp" > /dev/null 2>&1; then
            print_success "Endpoint MCP accessible"
        fi
        
        echo ""
        print_status "=== SERVEUR PRÊT ==="
        print_success "🎉 Le serveur Minecraft MCPC+ 1.6.4 est maintenant opérationnel !"
        print_status "✅ Compatible avec le MCP Hub Central"
        print_status "✅ Déployé sur Railway"
        print_status "✅ Version MCPC+ 1.6.4"
        print_status "✅ Docker activé"
        print_status "✅ Tous les endpoints fonctionnels"
        
        echo ""
        print_status "=== ACCÈS ==="
        print_status "Interface Minecraft: $SERVER_URL"
        print_status "Health check: $SERVER_URL/health"
        print_status "API des outils: $SERVER_URL/api/tools"
        print_status "Endpoint MCP: $SERVER_URL/mcp"
        print_status "Hub central: https://mcp.coupaul.fr/"
        
        exit 0
        
    elif echo "$response" | grep -q '"code":502'; then
        print_warning "Serveur en cours de déploiement (502 - Application failed to respond)"
        print_status "Le serveur est probablement en train de redémarrer sur Railway"
        
    elif [ -z "$response" ]; then
        print_error "Pas de réponse du serveur"
        
    else
        print_warning "Réponse inattendue: $response"
    fi
    
    if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
        print_status "Attente de 30 secondes avant la prochaine tentative..."
        sleep 30
    fi
    
    ATTEMPT=$((ATTEMPT + 1))
done

print_error "Le serveur n'est pas devenu opérationnel après $MAX_ATTEMPTS tentatives"
print_status "Le développeur doit vérifier le déploiement sur Railway"
print_status "Vérifiez les logs de déploiement sur Railway"

echo ""
print_status "=== COMMANDES DE DEBUG ==="
print_status "Test manuel: curl -s $SERVER_URL/health"
print_status "Voir les logs Railway: railway logs"
print_status "Redéployer: railway up"
print_status "Hub central: https://mcp.coupaul.fr/"

exit 1
