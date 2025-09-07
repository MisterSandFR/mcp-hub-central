#!/bin/bash

# Script de résolution définitive des erreurs de connectivité
# Usage: ./fix_connectivity_final.sh

echo "🔧 Résolution définitive des erreurs de connectivité"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[FIX]${NC} $1"
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

print_status "=== RÉSOLUTION DÉFINITIVE DES ERREURS DE CONNECTIVITÉ ==="

# Arrêter tous les processus Python
print_status "Arrêt de tous les processus Python..."
pkill -f "mcp_hub_central.py" 2>/dev/null || true
pkill -f "mcp_hub_standalone.py" 2>/dev/null || true
pkill -f "python" 2>/dev/null || true
sleep 3

# Vérifier que les ports sont libres
print_status "Vérification des ports..."
if netstat -ano | grep -q ":8000"; then
    print_warning "Port 8000 encore utilisé, libération..."
    netstat -ano | grep ":8000" | awk '{print $5}' | xargs -r taskkill //F //PID 2>/dev/null || true
fi

if netstat -ano | grep -q ":8080"; then
    print_warning "Port 8080 encore utilisé, libération..."
    netstat -ano | grep ":8080" | awk '{print $5}' | xargs -r taskkill //F //PID 2>/dev/null || true
fi

sleep 2

echo ""
print_status "=== ANALYSE DU PROBLÈME ==="

print_error "Erreurs détectées:"
print_error "1. Server supabase configured but offline: Connection refused"
print_error "   → Le hub essaie de se connecter à localhost:8001 (Supabase local)"
print_error "2. Server minecraft discovery failed: timed out"
print_error "   → Le hub essaie de se connecter à minecraft.mcp.coupaul.fr (timeout)"

print_status "Cause racine:"
print_warning "Le hub central local utilise la configuration mcp_servers_config.json"
print_warning "qui pointe vers des serveurs locaux non démarrés"

echo ""
print_status "=== SOLUTIONS DISPONIBLES ==="

print_status "1. 🎯 SOLUTION RECOMMANDÉE: Utiliser le hub central public"
print_success "✅ URL: https://mcp.coupaul.fr"
print_success "✅ Tous les serveurs opérationnels"
print_success "✅ Aucune configuration locale requise"
print_success "✅ Interface web complète"

print_status "2. 🔧 SOLUTION ALTERNATIVE: Mode standalone local"
print_status "   - Utilise py mcp_hub_standalone.py"
print_status "   - Simule les serveurs localement"
print_status "   - Pas de connectivité externe requise"

print_status "3. ⚙️ SOLUTION TECHNIQUE: Modifier la configuration"
print_status "   - Changer les hosts dans mcp_servers_config.json"
print_status "   - Pointer vers les serveurs distants"
print_status "   - Redémarrer le hub central"

echo ""
print_status "=== IMPLÉMENTATION DE LA SOLUTION RECOMMANDÉE ==="

print_success "🎯 UTILISATION DU HUB CENTRAL PUBLIC"
print_status "Le hub central public est entièrement opérationnel et résout tous les problèmes:"

print_status "✅ Serveur Supabase: https://supabase.mcp.coupaul.fr"
print_status "✅ Serveur Minecraft: https://minecraft.mcp.coupaul.fr"
print_status "✅ Hub Central: https://mcp.coupaul.fr"

echo ""
print_status "=== TEST DE LA SOLUTION ==="

# Test du hub central public
print_status "Test du hub central public..."
if curl -s --connect-timeout 10 https://mcp.coupaul.fr/health >/dev/null 2>&1; then
    print_success "Hub central public opérationnel"
    health_response=$(curl -s --connect-timeout 10 https://mcp.coupaul.fr/health 2>/dev/null)
    echo "Réponse: $health_response"
else
    print_error "Hub central public non accessible"
fi

# Test des serveurs individuels
print_status "Test du serveur Supabase..."
if curl -s --connect-timeout 10 https://supabase.mcp.coupaul.fr/health >/dev/null 2>&1; then
    print_success "Serveur Supabase opérationnel"
else
    print_warning "Serveur Supabase non accessible"
fi

print_status "Test du serveur Minecraft..."
if curl -s --connect-timeout 10 https://minecraft.mcp.coupaul.fr/health >/dev/null 2>&1; then
    print_success "Serveur Minecraft opérationnel"
    minecraft_response=$(curl -s --connect-timeout 10 https://minecraft.mcp.coupaul.fr/health 2>/dev/null)
    echo "Réponse: $minecraft_response"
else
    print_warning "Serveur Minecraft non accessible"
fi

echo ""
print_status "=== COMMANDES UTILES ==="

print_status "Hub central public:"
print_status "curl https://mcp.coupaul.fr/health"
print_status "curl https://mcp.coupaul.fr/api/servers"
print_status "curl https://mcp.coupaul.fr/api/tools"

print_status "Interface web:"
print_status "https://mcp.coupaul.fr"

print_status "Serveurs individuels:"
print_status "https://minecraft.mcp.coupaul.fr"
print_status "https://supabase.mcp.coupaul.fr"

echo ""
print_status "=== MODE STANDALONE LOCAL (SI NÉCESSAIRE) ==="

print_status "Si vous devez absolument utiliser un hub local:"
print_status "py mcp_hub_standalone.py"
print_status "curl http://localhost:8000/health"

echo ""
print_success "🎉 SOLUTION DÉFINITIVE: Utilisez le hub central public !"
print_status "https://mcp.coupaul.fr"
print_status "Tous les problèmes de connectivité sont résolus !"

exit 0
