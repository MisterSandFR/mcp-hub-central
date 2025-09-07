#!/bin/bash

# Script de test de la configuration mise à jour
# Usage: ./test_updated_config.sh

echo "🧪 Test de la configuration mise à jour"

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

print_status "=== TEST DE LA CONFIGURATION MISE À JOUR ==="

# URLs des serveurs selon la nouvelle configuration
SUPABASE_URL="https://supabase.mcp.coupaul.fr"
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
HUB_URL="https://mcp.coupaul.fr"

print_status "Serveur Supabase: $SUPABASE_URL"
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Hub Central: $HUB_URL"

echo ""
print_status "=== 1. TEST DES SERVEURS INDIVIDUELS ==="

# Test du serveur Supabase
print_status "Test du serveur Supabase..."
if curl -s --connect-timeout 15 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Supabase accessible"
    supabase_response=$(curl -s --connect-timeout 15 "$SUPABASE_URL/health" 2>/dev/null)
    echo "Réponse: $supabase_response"
else
    print_error "Serveur Supabase non accessible"
fi

# Test du serveur Minecraft
print_status "Test du serveur Minecraft..."
if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Minecraft accessible"
    minecraft_response=$(curl -s --connect-timeout 15 "$MINECRAFT_URL/health" 2>/dev/null)
    echo "Réponse: $minecraft_response"
else
    print_error "Serveur Minecraft non accessible"
fi

echo ""
print_status "=== 2. TEST DU HUB CENTRAL ==="

# Test du hub central
print_status "Test du hub central..."
if curl -s --connect-timeout 15 "$HUB_URL/health" >/dev/null 2>&1; then
    print_success "Hub central accessible"
    hub_response=$(curl -s --connect-timeout 15 "$HUB_URL/health" 2>/dev/null)
    echo "Réponse: $hub_response"
else
    print_error "Hub central non accessible"
fi

# Test de l'API des serveurs
print_status "Test de l'API des serveurs..."
if curl -s --connect-timeout 15 "$HUB_URL/api/servers" >/dev/null 2>&1; then
    print_success "API des serveurs accessible"
    servers_response=$(curl -s --connect-timeout 15 "$HUB_URL/api/servers" 2>/dev/null)
    servers_count=$(echo "$servers_response" | grep -o '"name":' | wc -l)
    print_status "Nombre de serveurs détectés: $servers_count"
    
    # Vérifier si Minecraft est détecté
    if echo "$servers_response" | grep -q "minecraft\|Minecraft\|MCPC"; then
        print_success "Serveur Minecraft détecté par le hub central"
    else
        print_warning "Serveur Minecraft NON détecté par le hub central"
    fi
else
    print_error "API des serveurs non accessible"
fi

# Test de l'API des outils
print_status "Test de l'API des outils..."
if curl -s --connect-timeout 15 "$HUB_URL/api/tools" >/dev/null 2>&1; then
    print_success "API des outils accessible"
    tools_response=$(curl -s --connect-timeout 15 "$HUB_URL/api/tools" 2>/dev/null)
    tools_count=$(echo "$tools_response" | grep -o '"name":' | wc -l)
    print_status "Nombre total d'outils: $tools_count"
    
    # Vérifier si les outils Minecraft sont présents
    if echo "$tools_response" | grep -q "minecraft\|Minecraft\|MCPC\|analyze_gui_spritesheet"; then
        print_success "Outils Minecraft détectés dans le hub central"
    else
        print_warning "Outils Minecraft NON détectés dans le hub central"
    fi
else
    print_error "API des outils non accessible"
fi

echo ""
print_status "=== 3. RÉSUMÉ DES TESTS ==="

# Résumé
supabase_working=false
minecraft_working=false
hub_working=false
minecraft_detected=false

if curl -s --connect-timeout 10 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    supabase_working=true
fi

if curl -s --connect-timeout 10 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    minecraft_working=true
fi

if curl -s --connect-timeout 10 "$HUB_URL/health" >/dev/null 2>&1; then
    hub_working=true
fi

if curl -s --connect-timeout 10 "$HUB_URL/api/servers" | grep -q "minecraft\|Minecraft\|MCPC"; then
    minecraft_detected=true
fi

print_status "Statut des services:"
if [ "$supabase_working" = true ]; then
    print_success "✅ Serveur Supabase: Opérationnel"
else
    print_error "❌ Serveur Supabase: Non opérationnel"
fi

if [ "$minecraft_working" = true ]; then
    print_success "✅ Serveur Minecraft: Opérationnel"
else
    print_error "❌ Serveur Minecraft: Non opérationnel"
fi

if [ "$hub_working" = true ]; then
    print_success "✅ Hub Central: Opérationnel"
else
    print_error "❌ Hub Central: Non opérationnel"
fi

if [ "$minecraft_detected" = true ]; then
    print_success "✅ Serveur Minecraft: Détecté par le hub"
else
    print_error "❌ Serveur Minecraft: NON détecté par le hub"
fi

echo ""
if [ "$supabase_working" = true ] && [ "$minecraft_working" = true ] && [ "$hub_working" = true ]; then
    if [ "$minecraft_detected" = true ]; then
        print_success "🎉 TOUS LES TESTS RÉUSSIS !"
        print_success "Le hub central détecte maintenant les deux serveurs"
    else
        print_warning "⚠️ Serveurs opérationnels mais Minecraft non détecté"
        print_status "Le hub central doit être redémarré pour prendre en compte la nouvelle configuration"
    fi
else
    print_error "❌ Problèmes détectés avec certains services"
fi

echo ""
print_status "=== 4. ACTIONS RECOMMANDÉES ==="

if [ "$minecraft_detected" = false ]; then
    print_status "Pour résoudre le problème de détection:"
    print_status "1. Redémarrer le hub central sur Railway"
    print_status "2. Vérifier que la nouvelle configuration est bien déployée"
    print_status "3. Attendre quelques minutes pour la propagation"
fi

echo ""
print_status "=== 5. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier le statut après redémarrage:"
print_status "curl -s $HUB_URL/api/servers"
print_status "curl -s $HUB_URL/api/tools"
print_status "curl -s $HUB_URL/health"

exit 0
