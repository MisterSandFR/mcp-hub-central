#!/bin/bash

# Script de diagnostic pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./diagnose_minecraft_502.sh

echo "🔍 Diagnostic de l'erreur 502 - Serveur Minecraft MCPC+ 1.6.4"

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

SERVER_URL="https://minecraft.mcp.coupaul.fr"

print_status "=== DIAGNOSTIC ERREUR 502 ==="
print_status "URL: $SERVER_URL"
print_status "Erreur: Application failed to respond"

echo ""
print_status "=== CAUSES POSSIBLES ==="
print_warning "1. Serveur en cours de déploiement sur Railway"
print_warning "2. Application non démarrée correctement"
print_warning "3. Problème de configuration Railway"
print_warning "4. Port non exposé correctement"
print_warning "5. Erreur dans le code de l'application"

echo ""
print_status "=== TESTS DE CONNECTIVITÉ ==="

# Test de connectivité de base
print_status "Test de connectivité de base..."
if curl -s --connect-timeout 10 "$SERVER_URL" > /dev/null 2>&1; then
    print_success "Serveur accessible (mais erreur 502)"
else
    print_error "Serveur non accessible"
fi

# Test avec différents endpoints
endpoints=("/health" "/api/tools" "/mcp" "/.well-known/mcp-config" "/mcp/info" "/mcp/tools")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de $endpoint..."
    response=$(curl -s --connect-timeout 5 "$SERVER_URL$endpoint" 2>/dev/null)
    
    if echo "$response" | grep -q '"code":502'; then
        print_warning "$endpoint: Erreur 502 - Application failed to respond"
    elif echo "$response" | grep -q '"status":"UP"'; then
        print_success "$endpoint: Fonctionnel"
    elif [ -n "$response" ]; then
        print_warning "$endpoint: Réponse inattendue"
    else
        print_error "$endpoint: Pas de réponse"
    fi
done

echo ""
print_status "=== SOLUTIONS RECOMMANDÉES ==="

print_status "1. Vérifier le déploiement Railway:"
print_status "   - Se connecter à Railway Dashboard"
print_status "   - Vérifier les logs de déploiement"
print_status "   - Vérifier que l'application démarre correctement"

print_status "2. Vérifier la configuration:"
print_status "   - Port 3000 exposé correctement"
print_status "   - Variables d'environnement configurées"
print_status "   - Dockerfile correct"

print_status "3. Redéployer si nécessaire:"
print_status "   - railway up"
print_status "   - Vérifier les logs en temps réel"

print_status "4. Tester localement:"
print_status "   - docker run -p 3000:3000 [image]"
print_status "   - Vérifier que l'application démarre"

echo ""
print_status "=== COMMANDES DE DEBUG ==="
print_status "Test manuel: curl -s $SERVER_URL/health"
print_status "Logs Railway: railway logs"
print_status "Redéployer: railway up"
print_status "Statut Railway: railway status"

echo ""
print_status "=== PROCHAINES ÉTAPES ==="
print_warning "Le développeur doit vérifier le déploiement sur Railway"
print_warning "L'erreur 502 indique que l'application ne répond pas"
print_warning "Cela peut être dû à un problème de démarrage ou de configuration"

echo ""
print_status "=== MONITORING ==="
print_status "Relancez ce script dans quelques minutes pour voir si le problème se résout"
print_status "Le déploiement Railway peut prendre plusieurs minutes"

exit 1
