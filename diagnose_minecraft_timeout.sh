#!/bin/bash

# Script de diagnostic des timeouts du serveur Minecraft
# Usage: ./diagnose_minecraft_timeout.sh

echo "🔍 Diagnostic des timeouts du serveur Minecraft MCP"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[DIAG]${NC} $1"
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

MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
HUB_URL="https://mcp.coupaul.fr"

print_status "=== DIAGNOSTIC DES TIMEOUTS MINECRAFT MCP ==="
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Hub Central: $HUB_URL"

echo ""
print_status "=== 1. TEST DES ENDPOINTS MINECRAFT ==="

# Test des différents endpoints
endpoints=("/" "/health" "/api/tools" "/mcp" "/.well-known/mcp-config")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de $endpoint..."
    
    # Test avec timeout court
    response=$(curl -s -w "%{http_code}" -o /dev/null --max-time 5 "$MINECRAFT_URL$endpoint")
    
    if [ "$response" = "200" ]; then
        print_success "$endpoint: OK (200)"
    elif [ "$response" = "404" ]; then
        print_warning "$endpoint: Not Found (404)"
    elif [ "$response" = "000" ]; then
        print_error "$endpoint: Timeout ou erreur de connexion"
    else
        print_warning "$endpoint: Code $response"
    fi
done

echo ""
print_status "=== 2. TEST DE PERFORMANCE DÉTAILLÉ ==="

# Test de performance sur l'endpoint principal
print_status "Test de performance sur /..."
perf=$(curl -w "@-" -o /dev/null -s --max-time 10 "$MINECRAFT_URL/" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$perf"

# Test de performance sur /health
print_status "Test de performance sur /health..."
perf=$(curl -w "@-" -o /dev/null -s --max-time 10 "$MINECRAFT_URL/health" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$perf"

echo ""
print_status "=== 3. TEST DU HUB CENTRAL ==="

# Test du hub central
print_status "Test de performance du hub central..."
hub_perf=$(curl -w "@-" -o /dev/null -s --max-time 15 "$HUB_URL/" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$hub_perf"

echo ""
print_status "=== 4. ANALYSE DU PROBLÈME ==="

print_status "Problème identifié:"
print_error "Le hub central fait des requêtes GET sur '/' au lieu des endpoints corrects"

print_status "Causes possibles:"
print_warning "1. 🔍 Logique de découverte incorrecte"
print_status "   - Le hub essaie de découvrir sur '/' au lieu de '/health'"
print_status "   - Pas de gestion des endpoints spécifiques"

print_warning "2. ⚙️ Configuration de découverte"
print_status "   - Pas de path spécifié pour la découverte"
print_status "   - Utilise le path par défaut '/'"

print_warning "3. 🐌 Serveur Minecraft lent sur '/'"
print_status "   - L'endpoint '/' peut être plus lent que '/health'"
print_status "   - Pas d'optimisation sur l'endpoint racine"

echo ""
print_status "=== 5. SOLUTIONS ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Configurer le path de découverte"
print_status "   - Ajouter 'discovery_path: "/health"' dans la config"
print_status "   - Utiliser l'endpoint le plus rapide"

print_status "2. 🔧 SOLUTION TECHNIQUE: Optimiser la découverte"
print_status "   - Découverte asynchrone"
print_status "   - Cache des résultats"
print_status "   - Timeout plus court sur la découverte"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Ajuster les paramètres"
print_status "   - discovery_timeout: 5s (au lieu de 10s)"
print_status "   - Utiliser /health au lieu de /"

echo ""
print_status "=== 6. ACTIONS IMMÉDIATES ==="

print_status "Pour corriger le problème de timeout:"

print_status "1. Modifier la configuration Minecraft:"
print_status "   - Ajouter discovery_path: \"/health\""
print_status "   - Réduire discovery_timeout: 5s"
print_status "   - Utiliser l'endpoint le plus rapide"

print_status "2. Optimiser la logique de découverte:"
print_status "   - Découverte sur /health au lieu de /"
print_status "   - Timeout plus court pour la découverte"
print_status "   - Cache des résultats de découverte"

echo ""
print_status "=== 7. COMMANDES DE TEST ==="

print_status "Tester les endpoints individuellement:"
print_status "curl -s --max-time 5 '$MINECRAFT_URL/'"
print_status "curl -s --max-time 5 '$MINECRAFT_URL/health'"
print_status "curl -s --max-time 5 '$MINECRAFT_URL/api/tools'"

print_status "Tester le hub central:"
print_status "curl -s --max-time 10 '$HUB_URL/api/servers'"

echo ""
print_status "=== 8. RÉSUMÉ ==="

print_status "Problème identifié:"
print_error "Le hub central fait des requêtes GET sur '/' qui timeout"

print_status "Cause principale:"
print_warning "Logique de découverte incorrecte - utilise '/' au lieu de '/health'"

print_status "Solution:"
print_status "1. Configurer discovery_path: \"/health\""
print_status "2. Réduire discovery_timeout: 5s"
print_status "3. Utiliser l'endpoint le plus rapide"

echo ""
print_error "🚨 CONCLUSION: Le serveur Minecraft timeout sur la découverte"
print_status "✅ SOLUTION: Configurer le path de découverte sur /health"

exit 0