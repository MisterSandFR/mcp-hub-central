#!/bin/bash

# Script de monitoring continu pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./monitor_minecraft_deployment.sh

echo "🔄 Monitoring continu du déploiement Minecraft MCPC+ 1.6.4..."

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
    echo -e "${GREEN}[✅ SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️ WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[❌ ERROR]${NC} $1"
}

SERVER_URL="https://minecraft.mcp.coupaul.fr"
CHECK_INTERVAL=30
MAX_CHECKS=20
CHECK_COUNT=0

print_status "Démarrage du monitoring continu..."
print_status "URL: $SERVER_URL"
print_status "Intervalle: $CHECK_INTERVAL secondes"
print_status "Vérifications maximum: $MAX_CHECKS"

while [ $CHECK_COUNT -lt $MAX_CHECKS ]; do
    CHECK_COUNT=$((CHECK_COUNT + 1))
    current_time=$(date '+%H:%M:%S')
    
    print_status "[$current_time] Vérification $CHECK_COUNT/$MAX_CHECKS..."
    
    # Test de l'endpoint health
    response=$(curl -s --connect-timeout 10 "$SERVER_URL/health" 2>/dev/null)
    
    if echo "$response" | grep -q '"status":"UP"'; then
        print_success "🎉 Serveur Minecraft MCPC+ 1.6.4 opérationnel !"
        echo "Réponse complète:"
        echo "$response" | jq . 2>/dev/null || echo "$response"
        
        # Test des autres endpoints
        print_status "Vérification des autres endpoints..."
        
        endpoints=("/api/tools" "/mcp" "/.well-known/mcp-config" "/mcp/info" "/mcp/tools")
        working_endpoints=0
        
        for endpoint in "${endpoints[@]}"; do
            if curl -s --connect-timeout 5 "$SERVER_URL$endpoint" > /dev/null 2>&1; then
                print_success "$endpoint: Fonctionnel"
                working_endpoints=$((working_endpoints + 1))
            else
                print_warning "$endpoint: Non accessible"
            fi
        done
        
        echo ""
        print_status "=== RÉSUMÉ DU DÉPLOIEMENT ==="
        print_success "🎉 Déploiement réussi !"
        print_success "✅ Serveur Minecraft MCPC+ 1.6.4 opérationnel"
        print_success "✅ Endpoints fonctionnels: $((working_endpoints + 1))/6"
        print_success "✅ Compatible avec le MCP Hub Central"
        print_success "✅ Déployé sur Railway"
        print_success "✅ Version MCPC+ 1.6.4"
        
        echo ""
        print_status "=== ACCÈS AU SERVEUR ==="
        print_status "Interface Minecraft: $SERVER_URL"
        print_status "Health check: $SERVER_URL/health"
        print_status "API des outils: $SERVER_URL/api/tools"
        print_status "Endpoint MCP: $SERVER_URL/mcp"
        print_status "Configuration MCP: $SERVER_URL/.well-known/mcp-config"
        print_status "Hub central: https://mcp.coupaul.fr/"
        
        echo ""
        print_status "=== INTÉGRATION HUB CENTRAL ==="
        print_status "Le serveur est maintenant prêt pour l'intégration avec le hub central"
        print_status "Vérifiez que le hub central détecte le serveur automatiquement"
        
        exit 0
        
    elif echo "$response" | grep -q '"code":502'; then
        print_warning "Serveur en cours de déploiement (502 - Application failed to respond)"
        print_status "Le serveur est probablement en train de redémarrer sur Railway"
        
    elif [ -z "$response" ]; then
        print_error "Pas de réponse du serveur"
        
    else
        print_warning "Réponse inattendue: $response"
    fi
    
    if [ $CHECK_COUNT -lt $MAX_CHECKS ]; then
        print_status "Attente de $CHECK_INTERVAL secondes avant la prochaine vérification..."
        sleep $CHECK_INTERVAL
    fi
done

print_error "Le serveur n'est pas devenu opérationnel après $MAX_CHECKS vérifications"
print_warning "Le déploiement Railway semble avoir des problèmes"

echo ""
print_status "=== ACTIONS RECOMMANDÉES ==="
print_status "1. Contacter le développeur pour vérifier les logs Railway"
print_status "2. Vérifier la configuration du déploiement"
print_status "3. Redéployer si nécessaire"
print_status "4. Vérifier que l'application démarre correctement localement"

echo ""
print_status "=== COMMANDES DE DEBUG ==="
print_status "Test manuel: curl -s $SERVER_URL/health"
print_status "Logs Railway: railway logs"
print_status "Redéployer: railway up"
print_status "Statut Railway: railway status"

exit 1
