#!/bin/bash

# Script de test pour vérifier le statut des serveurs MCP
# Usage: ./test_mcp_servers.sh

echo "🧪 Test des serveurs MCP..."

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

# Fonction pour tester un serveur
test_server() {
    local name=$1
    local port=$2
    local url="http://localhost:$port"
    
    print_status "Test de $name sur le port $port..."
    
    # Test de connectivité de base
    if curl -s --connect-timeout 5 "$url" > /dev/null 2>&1; then
        print_success "$name est accessible sur le port $port"
        
        # Test de l'endpoint health si disponible
        if curl -s --connect-timeout 5 "$url/health" > /dev/null 2>&1; then
            print_success "$name - Endpoint /health accessible"
        else
            print_warning "$name - Endpoint /health non accessible"
        fi
        
        # Test de l'endpoint API tools si disponible
        if curl -s --connect-timeout 5 "$url/api/tools" > /dev/null 2>&1; then
            print_success "$name - Endpoint /api/tools accessible"
        else
            print_warning "$name - Endpoint /api/tools non accessible"
        fi
        
        return 0
    else
        print_error "$name n'est pas accessible sur le port $port"
        return 1
    fi
}

# Test du hub central
print_status "=== TEST DU HUB CENTRAL ==="
test_server "MCP Hub Central" 8000

echo ""

# Test des serveurs MCP individuels
print_status "=== TEST DES SERVEURS MCP ==="
servers_online=0
total_servers=5

test_server "Supabase MCP Server" 8001 && ((servers_online++))
test_server "File Manager MCP Server" 8002 && ((servers_online++))
test_server "Git MCP Server" 8003 && ((servers_online++))
test_server "Web Scraping MCP Server" 8004 && ((servers_online++))
test_server "Minecraft MCP Server" 3000 && ((servers_online++))

echo ""

# Test de l'interface web
print_status "=== TEST DE L'INTERFACE WEB ==="
if curl -s --connect-timeout 10 "https://mcp.coupaul.fr/" > /dev/null 2>&1; then
    print_success "Interface web accessible sur https://mcp.coupaul.fr/"
else
    print_warning "Interface web non accessible sur https://mcp.coupaul.fr/"
fi

# Test des endpoints MCP
print_status "Test des endpoints MCP..."
if curl -s --connect-timeout 5 "http://localhost:8000/mcp" > /dev/null 2>&1; then
    print_success "Endpoint MCP accessible"
else
    print_error "Endpoint MCP non accessible"
fi

if curl -s --connect-timeout 5 "http://localhost:8000/.well-known/mcp-config" > /dev/null 2>&1; then
    print_success "Endpoint MCP Config accessible"
else
    print_error "Endpoint MCP Config non accessible"
fi

echo ""

# Résumé
print_status "=== RÉSUMÉ DES TESTS ==="
print_status "Serveurs MCP en ligne: $servers_online/$total_servers"

if [ $servers_online -eq $total_servers ]; then
    print_success "🎉 Tous les serveurs MCP sont opérationnels !"
    print_status "✅ Le problème des serveurs hors ligne est résolu"
    print_status "🌐 Accédez à l'interface: https://mcp.coupaul.fr/"
else
    print_warning "⚠️ Certains serveurs ne sont pas encore prêts"
    print_status "🔧 Vérifiez les logs avec: docker-compose logs"
fi

echo ""
print_status "=== COMMANDES UTILES ==="
print_status "Voir les logs: docker-compose logs -f"
print_status "Redémarrer: docker-compose restart"
print_status "Statut: docker-compose ps"
print_status "Diagnostic: ./diagnose_mcp.sh"

