#!/bin/bash

# Script de diagnostic pour les serveurs MCP
# Usage: ./diagnose_mcp.sh

echo "🔍 Diagnostic des serveurs MCP..."

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

# Vérifier Docker
print_status "Vérification de Docker..."
if command -v docker &> /dev/null; then
    print_success "Docker est installé: $(docker --version)"
else
    print_error "Docker n'est pas installé"
    exit 1
fi

# Vérifier Docker Compose
print_status "Vérification de Docker Compose..."
if command -v docker-compose &> /dev/null; then
    print_success "Docker Compose est installé: $(docker-compose --version)"
else
    print_error "Docker Compose n'est pas installé"
    exit 1
fi

# Vérifier les fichiers de configuration
print_status "Vérification des fichiers de configuration..."
if [ -f "mcp_servers_config.json" ]; then
    print_success "mcp_servers_config.json trouvé"
else
    print_error "mcp_servers_config.json manquant"
fi

if [ -f "docker-compose.yml" ]; then
    print_success "docker-compose.yml trouvé"
else
    print_error "docker-compose.yml manquant"
fi

# Vérifier les conteneurs Docker
print_status "Vérification des conteneurs Docker..."
echo ""
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Vérifier les ports utilisés
print_status "Vérification des ports utilisés..."
echo ""
netstat -tulpn | grep -E ":(8000|8001|8002|8003|8004|3000)" || print_warning "Aucun port MCP détecté"

# Tester la connectivité réseau
print_status "Test de connectivité réseau..."

test_port() {
    local port=$1
    local name=$2
    
    if nc -z localhost $port 2>/dev/null; then
        print_success "Port $port ($name) est ouvert"
    else
        print_warning "Port $port ($name) est fermé"
    fi
}

test_port 8000 "MCP Hub Central"
test_port 8001 "Supabase MCP Server"
test_port 8002 "File Manager MCP Server"
test_port 8003 "Git MCP Server"
test_port 8004 "Web Scraping MCP Server"
test_port 3000 "Minecraft MCP Server"

# Vérifier les logs des conteneurs
print_status "Vérification des logs récents..."
echo ""
print_status "Logs du MCP Hub Central:"
docker logs mcp-hub-central --tail 10 2>/dev/null || print_warning "Conteneur mcp-hub-central non trouvé"

echo ""
print_status "Logs du Supabase MCP Server:"
docker logs supabase-mcp-server --tail 10 2>/dev/null || print_warning "Conteneur supabase-mcp-server non trouvé"

# Vérifier la configuration réseau Docker
print_status "Vérification du réseau Docker..."
echo ""
docker network ls | grep mcp || print_warning "Réseau MCP non trouvé"

# Résumé des recommandations
echo ""
print_status "=== RECOMMANDATIONS ==="

if ! docker ps | grep -q mcp-hub-central; then
    print_warning "Le MCP Hub Central n'est pas démarré"
    print_status "Commande: docker-compose up -d mcp-hub-central"
fi

if ! docker ps | grep -q supabase-mcp-server; then
    print_warning "Le Supabase MCP Server n'est pas démarré"
    print_status "Commande: docker-compose up -d supabase-mcp-server"
fi

if ! nc -z localhost 8000 2>/dev/null; then
    print_error "Le port 8000 (MCP Hub Central) n'est pas accessible"
    print_status "Vérifiez que le conteneur est démarré et que le port n'est pas utilisé par un autre service"
fi

if ! nc -z localhost 8001 2>/dev/null; then
    print_error "Le port 8001 (Supabase MCP Server) n'est pas accessible"
    print_status "Vérifiez que le conteneur Supabase est démarré"
fi

echo ""
print_status "Pour démarrer tous les services:"
print_status "  ./start_mcp_servers.sh"
print_status ""
print_status "Pour voir tous les logs:"
print_status "  docker-compose logs -f"
print_status ""
print_status "Pour redémarrer un service spécifique:"
print_status "  docker-compose restart <nom-du-service>"

