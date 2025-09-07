#!/bin/bash

# Script de démarrage pour les serveurs MCP réellement déployés
# Usage: ./start_deployed_servers.sh

echo "🚀 Démarrage des serveurs MCP déployés (Supabase + Minecraft)..."

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

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

print_status "Arrêt des conteneurs existants..."
docker-compose down

print_status "Démarrage du MCP Hub Central..."
docker-compose up -d mcp-hub-central

print_status "Attente du démarrage du hub central..."
sleep 5

print_status "Démarrage du serveur Supabase MCP..."
docker-compose up -d supabase-mcp-server

print_status "Démarrage du serveur Minecraft MCP..."
docker-compose up -d minecraft-mcp-server

# Attendre que les conteneurs soient prêts
print_status "Attente du démarrage des conteneurs..."
sleep 10

# Vérifier le statut des conteneurs
print_status "Vérification du statut des conteneurs..."
docker-compose ps

# Tester la connectivité des serveurs MCP
print_status "Test de connectivité des serveurs MCP..."

# Fonction pour tester un serveur
test_server() {
    local name=$1
    local port=$2
    local url="http://localhost:$port/health"
    
    print_status "Test de $name sur le port $port..."
    
    if curl -s --connect-timeout 5 "$url" > /dev/null; then
        print_success "$name est en ligne sur le port $port"
        return 0
    else
        print_warning "$name n'est pas accessible sur le port $port"
        return 1
    fi
}

# Tester chaque serveur déployé
servers_online=0
total_servers=2

test_server "MCP Hub Central" 8000 && ((servers_online++))
test_server "Supabase MCP Server" 8001 && ((servers_online++))
test_server "Minecraft MCP Server" 3000 && ((servers_online++))

# Résumé
echo ""
print_status "=== RÉSUMÉ ==="
print_status "Serveurs MCP en ligne: $servers_online/$total_servers"

if [ $servers_online -eq $total_servers ]; then
    print_success "Tous les serveurs MCP déployés sont opérationnels !"
    print_status "Accédez au hub central: http://localhost:8000"
    print_status "Accédez à l'interface web: https://mcp.coupaul.fr"
    print_status "Serveurs disponibles:"
    print_status "  - Supabase MCP Server (port 8001)"
    print_status "  - Minecraft MCP Server (port 3000)"
else
    print_warning "Certains serveurs ne sont pas encore prêts"
    print_status "Vérifiez les logs avec: docker-compose logs"
fi

echo ""
print_status "Commandes utiles:"
print_status "  - Voir les logs: docker-compose logs -f"
print_status "  - Arrêter les services: docker-compose down"
print_status "  - Redémarrer: docker-compose restart"
print_status "  - Statut: docker-compose ps"
print_status "  - Test complet: ./test_mcp_servers.sh"

