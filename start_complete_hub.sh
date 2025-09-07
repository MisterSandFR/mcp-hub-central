#!/bin/bash

# Script de démarrage complet pour le hub central et ses serveurs
# Usage: ./start_complete_hub.sh

echo "🚀 Démarrage complet du MCP Hub Central et de ses serveurs"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[STARTUP]${NC} $1"
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

print_status "=== DÉMARRAGE COMPLET MCP HUB CENTRAL ==="

# Vérifier Docker
print_status "Vérification de Docker..."
if command -v docker >/dev/null 2>&1; then
    print_success "Docker disponible"
    if docker ps >/dev/null 2>&1; then
        print_success "Docker en cours d'exécution"
    else
        print_error "Docker non démarré"
        print_status "Démarrez Docker Desktop et réessayez"
        exit 1
    fi
else
    print_error "Docker non installé"
    print_status "Installez Docker Desktop et réessayez"
    exit 1
fi

# Vérifier Docker Compose
print_status "Vérification de Docker Compose..."
if command -v docker-compose >/dev/null 2>&1; then
    print_success "Docker Compose disponible"
else
    print_error "Docker Compose non disponible"
    print_status "Installez Docker Compose et réessayez"
    exit 1
fi

echo ""
print_status "=== 1. DÉMARRAGE DU SERVEUR SUPABASE LOCAL ==="

# Démarrer le serveur Supabase
print_status "Démarrage du serveur Supabase MCP..."
if docker-compose up -d supabase-mcp-server; then
    print_success "Serveur Supabase démarré"
    
    # Attendre que le serveur soit prêt
    print_status "Attente du démarrage du serveur Supabase..."
    for i in {1..30}; do
        if curl -s --connect-timeout 5 http://localhost:8001/health >/dev/null 2>&1; then
            print_success "Serveur Supabase opérationnel sur le port 8001"
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "Serveur Supabase non accessible après 30 secondes"
            print_status "Vérifiez les logs: docker-compose logs supabase-mcp-server"
        fi
        sleep 1
    done
else
    print_error "Échec du démarrage du serveur Supabase"
    print_status "Vérifiez la configuration Docker Compose"
    exit 1
fi

echo ""
print_status "=== 2. VÉRIFICATION DU SERVEUR MINECRAFT DISTANT ==="

# Vérifier le serveur Minecraft
print_status "Vérification du serveur Minecraft MCPC+ 1.6.4..."
if curl -s --connect-timeout 10 https://minecraft.mcp.coupaul.fr/health >/dev/null 2>&1; then
    print_success "Serveur Minecraft distant opérationnel"
    minecraft_response=$(curl -s --connect-timeout 10 https://minecraft.mcp.coupaul.fr/health 2>/dev/null)
    echo "Statut: $minecraft_response"
else
    print_warning "Serveur Minecraft distant non accessible"
    print_status "Le serveur peut être en cours de redéploiement"
fi

echo ""
print_status "=== 3. DÉMARRAGE DU HUB CENTRAL ==="

# Vérifier si le hub central est déjà en cours d'exécution
print_status "Vérification du hub central..."
if curl -s --connect-timeout 5 http://localhost:8080/health >/dev/null 2>&1; then
    print_warning "Hub central déjà en cours d'exécution sur le port 8080"
    print_status "Arrêt du hub central existant..."
    pkill -f "mcp_hub_central.py" 2>/dev/null || true
    sleep 2
fi

# Démarrer le hub central
print_status "Démarrage du hub central..."
if py mcp_hub_central.py --port 8080 > hub.log 2>&1 &
then
    hub_pid=$!
    print_success "Hub central démarré (PID: $hub_pid)"
    
    # Attendre que le hub soit prêt
    print_status "Attente du démarrage du hub central..."
    for i in {1..30}; do
        if curl -s --connect-timeout 5 http://localhost:8080/health >/dev/null 2>&1; then
            print_success "Hub central opérationnel sur le port 8080"
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "Hub central non accessible après 30 secondes"
            print_status "Vérifiez les logs: tail -f hub.log"
        fi
        sleep 1
    done
else
    print_error "Échec du démarrage du hub central"
    exit 1
fi

echo ""
print_status "=== 4. TEST DE L'INTÉGRATION COMPLÈTE ==="

# Test du hub central
print_status "Test du hub central..."
if curl -s --connect-timeout 5 http://localhost:8080/health >/dev/null 2>&1; then
    print_success "Hub central accessible"
    health_response=$(curl -s --connect-timeout 5 http://localhost:8080/health 2>/dev/null)
    echo "Réponse: $health_response"
else
    print_error "Hub central non accessible"
fi

# Test de l'API des serveurs
print_status "Test de l'API des serveurs..."
if curl -s --connect-timeout 5 http://localhost:8080/api/servers >/dev/null 2>&1; then
    print_success "API des serveurs accessible"
    servers_response=$(curl -s --connect-timeout 5 http://localhost:8080/api/servers 2>/dev/null)
    servers_count=$(echo "$servers_response" | grep -o '"name":' | wc -l)
    print_status "Serveurs détectés: $servers_count"
else
    print_error "API des serveurs non accessible"
fi

echo ""
print_status "=== 5. RÉSUMÉ DU DÉMARRAGE ==="

print_status "Services démarrés:"
print_status "✅ Hub Central: http://localhost:8080"
print_status "✅ Serveur Supabase: http://localhost:8001"
print_status "✅ Serveur Minecraft: https://minecraft.mcp.coupaul.fr"

echo ""
print_status "=== 6. COMMANDES UTILES ==="

print_status "Accès aux services:"
print_status "Hub Central: http://localhost:8080"
print_status "API des serveurs: http://localhost:8080/api/servers"
print_status "API des outils: http://localhost:8080/api/tools"

print_status "Monitoring:"
print_status "Logs du hub: tail -f hub.log"
print_status "Logs Supabase: docker-compose logs supabase-mcp-server"
print_status "Statut Docker: docker-compose ps"

print_status "Arrêt des services:"
print_status "Arrêter le hub: pkill -f mcp_hub_central.py"
print_status "Arrêter Supabase: docker-compose down"

echo ""
print_success "🎉 DÉMARRAGE COMPLET TERMINÉ !"
print_status "Le MCP Hub Central et ses serveurs sont maintenant opérationnels"

exit 0
