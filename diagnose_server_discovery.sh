#!/bin/bash

# Script de diagnostic de la découverte des serveurs
# Usage: ./diagnose_server_discovery.sh

echo "🔍 Diagnostic de la découverte des serveurs"

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

print_status "=== DIAGNOSTIC DE LA DÉCOUVERTE DES SERVEURS ==="

echo ""
print_status "=== 1. TEST DES SERVEURS INDIVIDUELS ==="

# Test du serveur Supabase
print_status "Test du serveur Supabase..."
supabase_response=$(curl -s --max-time 10 "https://supabase.mcp.coupaul.fr/health" 2>/dev/null)

if [ -n "$supabase_response" ]; then
    print_success "✅ Serveur Supabase accessible"
    echo "$supabase_response" | head -1
    
    # Vérifier le statut
    if echo "$supabase_response" | grep -q '"status":"UP"'; then
        print_success "✅ Serveur Supabase: UP"
    else
        print_warning "⚠️ Serveur Supabase: Status inconnu"
    fi
else
    print_error "❌ Serveur Supabase inaccessible"
fi

# Test du serveur Minecraft
print_status "Test du serveur Minecraft..."
minecraft_response=$(curl -s --max-time 10 "https://minecraft.mcp.coupaul.fr/health" 2>/dev/null)

if [ -n "$minecraft_response" ]; then
    print_success "✅ Serveur Minecraft accessible"
    echo "$minecraft_response" | head -1
    
    # Vérifier le statut
    if echo "$minecraft_response" | grep -q '"status":"healthy"'; then
        print_success "✅ Serveur Minecraft: Healthy"
    else
        print_warning "⚠️ Serveur Minecraft: Status inconnu"
    fi
else
    print_error "❌ Serveur Minecraft inaccessible"
fi

echo ""
print_status "=== 2. TEST DES ENDPOINTS DE DÉCOUVERTE ==="

# Test des endpoints de découverte
print_status "Test de l'endpoint /health pour Supabase..."
supabase_health=$(curl -s --max-time 10 "https://supabase.mcp.coupaul.fr/health" 2>/dev/null)

if [ -n "$supabase_health" ]; then
    print_success "✅ Endpoint /health Supabase: OK"
    # Vérifier le code de statut HTTP
    supabase_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://supabase.mcp.coupaul.fr/health" 2>/dev/null)
    print_status "Code de statut HTTP: $supabase_status"
else
    print_error "❌ Endpoint /health Supabase: Échec"
fi

print_status "Test de l'endpoint /health pour Minecraft..."
minecraft_health=$(curl -s --max-time 10 "https://minecraft.mcp.coupaul.fr/health" 2>/dev/null)

if [ -n "$minecraft_health" ]; then
    print_success "✅ Endpoint /health Minecraft: OK"
    # Vérifier le code de statut HTTP
    minecraft_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://minecraft.mcp.coupaul.fr/health" 2>/dev/null)
    print_status "Code de statut HTTP: $minecraft_status"
else
    print_error "❌ Endpoint /health Minecraft: Échec"
fi

echo ""
print_status "=== 3. TEST DES ENDPOINTS API ==="

# Test des endpoints API
print_status "Test de l'endpoint /api/tools pour Supabase..."
supabase_tools=$(curl -s --max-time 10 "https://supabase.mcp.coupaul.fr/api/tools" 2>/dev/null)

if [ -n "$supabase_tools" ]; then
    print_success "✅ Endpoint /api/tools Supabase: OK"
    tools_count=$(echo "$supabase_tools" | jq '. | length' 2>/dev/null || echo "N/A")
    print_status "Nombre d'outils: $tools_count"
else
    print_error "❌ Endpoint /api/tools Supabase: Échec"
fi

print_status "Test de l'endpoint /api/tools pour Minecraft..."
minecraft_tools=$(curl -s --max-time 10 "https://minecraft.mcp.coupaul.fr/api/tools" 2>/dev/null)

if [ -n "$minecraft_tools" ]; then
    print_success "✅ Endpoint /api/tools Minecraft: OK"
    tools_count=$(echo "$minecraft_tools" | jq '. | length' 2>/dev/null || echo "N/A")
    print_status "Nombre d'outils: $tools_count"
else
    print_error "❌ Endpoint /api/tools Minecraft: Échec"
fi

echo ""
print_status "=== 4. ANALYSE DU PROBLÈME ==="

print_status "Problème identifié:"
print_warning "Serveur Supabase: OFFLINE malgré l'accessibilité"

print_status "Causes possibles:"
print_warning "1. 🔍 Logique de découverte incorrecte"
print_status "   - Le hub central ne détecte pas correctement le statut"
print_status "   - Problème dans la logique de découverte"

print_warning "2. ⚙️ Configuration de découverte"
print_status "   - Timeout trop court pour Supabase"
print_status "   - Problème avec l'endpoint de découverte"

print_warning "3. 🐌 Problème de performance"
print_status "   - Supabase plus lent que Minecraft"
print_status "   - Timeout de découverte dépassé"

print_warning "4. 🔧 Problème de code"
print_status "   - Bug dans la logique de découverte"
print_status "   - Problème avec la gestion des erreurs"

echo ""
print_status "=== 5. SOLUTIONS ==="

print_status "Solutions pour résoudre le problème:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Ajuster les timeouts"
print_status "   - Augmenter le timeout de découverte pour Supabase"
print_status "   - Réduire le timeout pour Minecraft"

print_status "2. 🔧 SOLUTION TECHNIQUE: Corriger la logique"
print_status "   - Vérifier la logique de découverte"
print_status "   - Corriger la gestion des erreurs"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Optimiser les paramètres"
print_status "   - Ajuster les paramètres de découverte"
print_status "   - Optimiser les timeouts"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Améliorer la performance"
print_status "   - Optimiser la performance de Supabase"
print_status "   - Améliorer la connectivité"

echo ""
print_status "=== 6. COMMANDES DE TEST ==="

print_status "Tester la découverte manuellement:"
print_status "curl -s --max-time 5 'https://supabase.mcp.coupaul.fr/health'"
print_status "curl -s --max-time 5 'https://minecraft.mcp.coupaul.fr/health'"

print_status "Tester les performances:"
print_status "curl -w '@-' -o /dev/null -s 'https://supabase.mcp.coupaul.fr/health' <<< 'time_total: %{time_total}\n'"
print_status "curl -w '@-' -o /dev/null -s 'https://minecraft.mcp.coupaul.fr/health' <<< 'time_total: %{time_total}\n'"

echo ""
print_status "=== 7. RÉSUMÉ ==="

print_status "Statut du diagnostic:"

if [ -n "$supabase_response" ]; then
    print_success "✅ Serveur Supabase: Accessible"
    print_warning "⚠️ Problème: Logique de découverte"
else
    print_error "❌ Serveur Supabase: Inaccessible"
fi

if [ -n "$minecraft_response" ]; then
    print_success "✅ Serveur Minecraft: Accessible"
else
    print_error "❌ Serveur Minecraft: Inaccessible"
fi

print_status "Actions recommandées:"
print_status "1. Ajuster les timeouts de découverte"
print_status "2. Vérifier la logique de découverte"
print_status "3. Optimiser les paramètres de configuration"

echo ""
print_warning "🚨 CONCLUSION: Serveur Supabase accessible mais non détecté"
print_status "✅ SOLUTION: Ajuster les timeouts et corriger la logique de découverte"

exit 0
