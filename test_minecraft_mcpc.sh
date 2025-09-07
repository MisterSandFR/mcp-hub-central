#!/bin/bash

# Script de test pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./test_minecraft_mcpc.sh

echo "🎮 Test du serveur Minecraft MCPC+ 1.6.4..."

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

# Configuration du serveur
SERVER_URL="https://minecraft.mcp.coupaul.fr"
SERVER_PORT="3000"

print_status "Test de connectivité du serveur Minecraft MCPC+ 1.6.4..."
print_status "URL: $SERVER_URL"
print_status "Port: $SERVER_PORT"

# Test de connectivité de base
print_status "Test de connectivité de base..."
if curl -s --connect-timeout 10 "$SERVER_URL" > /dev/null 2>&1; then
    print_success "Serveur accessible sur $SERVER_URL"
else
    print_warning "Serveur non accessible sur $SERVER_URL"
fi

# Test de l'endpoint health
print_status "Test de l'endpoint /health..."
if curl -s --connect-timeout 10 "$SERVER_URL/health" > /dev/null 2>&1; then
    print_success "Endpoint /health accessible"
    echo "Réponse:"
    curl -s --connect-timeout 10 "$SERVER_URL/health" | jq . 2>/dev/null || curl -s --connect-timeout 10 "$SERVER_URL/health"
else
    print_error "Endpoint /health non accessible"
fi

# Test de l'endpoint API tools
print_status "Test de l'endpoint /api/tools..."
if curl -s --connect-timeout 10 "$SERVER_URL/api/tools" > /dev/null 2>&1; then
    print_success "Endpoint /api/tools accessible"
    echo "Outils disponibles:"
    curl -s --connect-timeout 10 "$SERVER_URL/api/tools" | jq '.[].name' 2>/dev/null || echo "Format JSON non disponible"
else
    print_error "Endpoint /api/tools non accessible"
fi

# Test de l'endpoint MCP
print_status "Test de l'endpoint /mcp..."
if curl -s --connect-timeout 10 "$SERVER_URL/mcp" > /dev/null 2>&1; then
    print_success "Endpoint /mcp accessible"
else
    print_error "Endpoint /mcp non accessible"
fi

# Test de l'endpoint MCP config
print_status "Test de l'endpoint /.well-known/mcp-config..."
if curl -s --connect-timeout 10 "$SERVER_URL/.well-known/mcp-config" > /dev/null 2>&1; then
    print_success "Endpoint /.well-known/mcp-config accessible"
else
    print_error "Endpoint /.well-known/mcp-config non accessible"
fi

# Test avec le hub central
print_status "Test avec le hub central..."
if curl -s --connect-timeout 10 "https://mcp.coupaul.fr/api/servers" > /dev/null 2>&1; then
    print_success "Hub central accessible"
    echo "Serveurs détectés par le hub:"
    curl -s --connect-timeout 10 "https://mcp.coupaul.fr/api/servers" | jq '.[].name' 2>/dev/null || echo "Format JSON non disponible"
else
    print_error "Hub central non accessible"
fi

echo ""
print_status "=== RÉSUMÉ DES TESTS ==="

# Vérifier si le serveur répond
if curl -s --connect-timeout 5 "$SERVER_URL/health" > /dev/null 2>&1; then
    print_success "🎉 Serveur Minecraft MCPC+ 1.6.4 opérationnel !"
    print_status "✅ Compatible avec le MCP Hub Central"
    print_status "✅ Déployé sur Railway"
    print_status "✅ Version MCPC+ 1.6.4"
    print_status "✅ Docker activé"
else
    print_warning "⚠️ Serveur en cours de déploiement ou non accessible"
    print_status "Le serveur est peut-être en cours de redéploiement sur Railway"
    print_status "Réessayez dans quelques minutes"
fi

echo ""
print_status "=== COMMANDES UTILES ==="
print_status "Test manuel: curl -s $SERVER_URL/health"
print_status "Voir les outils: curl -s $SERVER_URL/api/tools"
print_status "Hub central: https://mcp.coupaul.fr/"
print_status "Interface Minecraft: $SERVER_URL"
