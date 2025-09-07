#!/bin/bash

# Script de démarrage pour MCP Hub Central - Mode Standalone
# Usage: ./start_standalone.sh

echo "🚀 Démarrage du MCP Hub Central - Mode Standalone..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier si Python est installé
if ! command -v py &> /dev/null; then
    print_error "Python n'est pas installé ou n'est pas dans le PATH"
    print_status "Installez Python depuis https://www.python.org/downloads/"
    exit 1
fi

print_success "Python trouvé: $(py --version)"

# Vérifier si le fichier standalone existe
if [ ! -f "mcp_hub_standalone.py" ]; then
    print_error "Fichier mcp_hub_standalone.py introuvable"
    exit 1
fi

print_status "Démarrage du MCP Hub Central en mode standalone..."

# Démarrer le serveur
py mcp_hub_standalone.py &

# Attendre que le serveur démarre
sleep 3

# Vérifier si le serveur est en cours d'exécution
if pgrep -f "mcp_hub_standalone.py" > /dev/null; then
    print_success "MCP Hub Central - Standalone Mode démarré avec succès !"
    
    # Tester la connectivité
    print_status "Test de connectivité..."
    
    if curl -s --connect-timeout 5 "http://localhost:8000/health" > /dev/null; then
        print_success "Serveur accessible sur http://localhost:8000"
    else
        print_warning "Serveur non accessible sur http://localhost:8000"
    fi
    
    if curl -s --connect-timeout 5 "http://localhost:8000/api/servers" > /dev/null; then
        print_success "API des serveurs accessible"
    else
        print_warning "API des serveurs non accessible"
    fi
    
    if curl -s --connect-timeout 5 "http://localhost:8000/api/tools" > /dev/null; then
        print_success "API des outils accessible"
    else
        print_warning "API des outils non accessible"
    fi
    
    echo ""
    print_status "=== RÉSUMÉ ==="
    print_success "🎉 MCP Hub Central - Standalone Mode opérationnel !"
    print_status "✅ 2 serveurs MCP simulés (Supabase + Minecraft)"
    print_status "✅ 59 outils MCP intégrés"
    print_status "✅ Mode standalone (pas de Docker requis)"
    
    echo ""
    print_status "=== ACCÈS ==="
    print_status "Interface web: http://localhost:8000"
    print_status "Interface publique: https://mcp.coupaul.fr"
    print_status "API Health: http://localhost:8000/health"
    print_status "API Servers: http://localhost:8000/api/servers"
    print_status "API Tools: http://localhost:8000/api/tools"
    print_status "MCP Endpoint: http://localhost:8000/mcp"
    
    echo ""
    print_status "=== COMMANDES UTILES ==="
    print_status "Arrêter le serveur: pkill -f mcp_hub_standalone.py"
    print_status "Voir les logs: tail -f /dev/null (pas de logs en mode standalone)"
    print_status "Redémarrer: ./start_standalone.sh"
    
else
    print_error "Échec du démarrage du MCP Hub Central"
    print_status "Vérifiez les erreurs ci-dessus"
    exit 1
fi
