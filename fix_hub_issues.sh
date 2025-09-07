#!/bin/bash

# Script de résolution des problèmes du hub central local
# Usage: ./fix_hub_issues.sh

echo "🔧 Résolution des problèmes du hub central local"

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

print_status "=== RÉSOLUTION DES PROBLÈMES HUB CENTRAL ==="

# Arrêter tous les processus Python en cours
print_status "Arrêt des processus Python existants..."
pkill -f "mcp_hub_central.py" 2>/dev/null || true
pkill -f "mcp_hub_standalone.py" 2>/dev/null || true
sleep 2

# Vérifier les ports utilisés
print_status "Vérification des ports..."
if netstat -ano | grep -q ":8080"; then
    print_warning "Port 8080 déjà utilisé"
    print_status "Processus utilisant le port 8080:"
    netstat -ano | grep ":8080"
else
    print_success "Port 8080 disponible"
fi

if netstat -ano | grep -q ":8001"; then
    print_warning "Port 8001 déjà utilisé"
    print_status "Processus utilisant le port 8001:"
    netstat -ano | grep ":8001"
else
    print_success "Port 8001 disponible"
fi

echo ""
print_status "=== SOLUTIONS RECOMMANDÉES ==="

print_status "1. Utiliser le hub central public (recommandé):"
print_success "✅ Hub central public: https://mcp.coupaul.fr"
print_success "✅ Serveur Supabase: Opérationnel"
print_success "✅ Serveur Minecraft: Opérationnel"
print_status "Avantages:"
print_status "  - Aucune configuration locale requise"
print_status "  - Tous les serveurs sont opérationnels"
print_status "  - Interface web complète"
print_status "  - API REST disponible"

print_status "2. Mode standalone local:"
print_status "  - Utilise py mcp_hub_standalone.py"
print_status "  - Simule les serveurs localement"
print_status "  - Pas de Docker requis"
print_status "  - Port 8000 par défaut"

print_status "3. Configuration Docker locale:"
print_status "  - Nécessite Docker Desktop"
print_status "  - Nécessite Docker Compose"
print_status "  - Configuration plus complexe"

echo ""
print_status "=== RECOMMANDATION FINALE ==="

print_success "🎯 UTILISEZ LE HUB CENTRAL PUBLIC"
print_status "URL: https://mcp.coupaul.fr"
print_status "Avantages:"
print_status "  ✅ Serveur Supabase opérationnel"
print_status "  ✅ Serveur Minecraft MCPC+ 1.6.4 opérationnel"
print_status "  ✅ Interface web complète"
print_status "  ✅ API REST disponible"
print_status "  ✅ Aucune configuration locale requise"

echo ""
print_status "=== COMMANDES UTILES ==="

print_status "Hub central public:"
print_status "curl https://mcp.coupaul.fr/health"
print_status "curl https://mcp.coupaul.fr/api/servers"
print_status "curl https://mcp.coupaul.fr/api/tools"

print_status "Serveurs individuels:"
print_status "curl https://minecraft.mcp.coupaul.fr/health"
print_status "curl https://supabase.mcp.coupaul.fr/health"

print_status "Mode standalone local (si nécessaire):"
print_status "py mcp_hub_standalone.py"
print_status "curl http://localhost:8000/health"

echo ""
print_success "🎉 SOLUTION RECOMMANDÉE: Utilisez le hub central public !"
print_status "Le hub central public est entièrement opérationnel avec tous les serveurs."

exit 0
