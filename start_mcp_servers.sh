#!/bin/bash

# Script de démarrage pour tous les serveurs MCP
# Usage: ./start_mcp_servers.sh

echo "🚀 Démarrage des serveurs MCP..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages colorés
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

print_status "Vérification de la configuration..."

# Vérifier si le fichier de configuration existe
if [ ! -f "mcp_servers_config.json" ]; then
    print_error "Fichier mcp_servers_config.json introuvable"
    exit 1
fi

# Vérifier si le fichier docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    print_error "Fichier docker-compose.yml introuvable"
    exit 1
fi

print_status "Arrêt des conteneurs existants..."
docker-compose down

print_status "Construction et démarrage des conteneurs..."
docker-compose up -d --build

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

# Tester chaque serveur
servers_online=0
total_servers=5

test_server "MCP Hub Central" 8000 && ((servers_online++))
test_server "Supabase MCP Server" 8001 && ((servers_online++))
test_server "File Manager MCP Server" 8002 && ((servers_online++))
test_server "Git MCP Server" 8003 && ((servers_online++))
test_server "Web Scraping MCP Server" 8004 && ((servers_online++))

# Résumé
echo ""
print_status "=== RÉSUMÉ ==="
print_status "Serveurs en ligne: $servers_online/$total_servers"

if [ $servers_online -eq $total_servers ]; then
    print_success "Tous les serveurs MCP sont opérationnels !"
    print_status "Accédez au hub central: http://localhost:8000"
    print_status "Accédez à l'interface web: https://mcp.coupaul.fr"
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

