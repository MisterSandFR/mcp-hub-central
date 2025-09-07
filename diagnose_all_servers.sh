#!/bin/bash

# Script de diagnostic complet des serveurs MCP
# Usage: ./diagnose_all_servers.sh

echo "🔍 Diagnostic complet de tous les serveurs MCP"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[DIAGNOSTIC]${NC} $1"
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

HUB_URL="https://mcp.coupaul.fr"
SUPABASE_URL="https://supabase.mcp.coupaul.fr"
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"

print_status "=== DIAGNOSTIC COMPLET DES SERVEURS MCP ==="
print_status "Hub Central: $HUB_URL"
print_status "Serveur Supabase: $SUPABASE_URL"
print_status "Serveur Minecraft: $MINECRAFT_URL"

echo ""
print_status "=== 1. TEST DU HUB CENTRAL PUBLIC ==="

# Test du hub central
print_status "Test du hub central..."
if curl -s --connect-timeout 10 "$HUB_URL/health" >/dev/null 2>&1; then
    print_success "Hub central accessible"
    health_response=$(curl -s --connect-timeout 10 "$HUB_URL/health" 2>/dev/null)
    echo "Réponse: $health_response"
else
    print_error "Hub central non accessible"
fi

# Test de l'API des serveurs
print_status "Test de l'API des serveurs..."
if curl -s --connect-timeout 10 "$HUB_URL/api/servers" >/dev/null 2>&1; then
    print_success "API des serveurs accessible"
    servers_response=$(curl -s --connect-timeout 10 "$HUB_URL/api/servers" 2>/dev/null)
    servers_count=$(echo "$servers_response" | grep -o '"name":' | wc -l)
    print_status "Nombre de serveurs détectés: $servers_count"
    
    # Vérifier si Minecraft est détecté
    if echo "$servers_response" | grep -q "minecraft\|Minecraft\|MCPC"; then
        print_success "Serveur Minecraft détecté par le hub central"
    else
        print_warning "Serveur Minecraft NON détecté par le hub central"
        print_status "Serveurs détectés:"
        echo "$servers_response" | grep -o '"name":"[^"]*"' | cut -d'"' -f4
    fi
else
    print_error "API des serveurs non accessible"
fi

echo ""
print_status "=== 2. TEST DU SERVEUR SUPABASE ==="

# Test du serveur Supabase
print_status "Test du serveur Supabase..."
if curl -s --connect-timeout 10 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Supabase accessible"
    supabase_response=$(curl -s --connect-timeout 10 "$SUPABASE_URL/health" 2>/dev/null)
    echo "Réponse: $supabase_response"
else
    print_error "Serveur Supabase non accessible"
fi

echo ""
print_status "=== 3. TEST DU SERVEUR MINECRAFT ==="

# Test du serveur Minecraft
print_status "Test du serveur Minecraft..."
if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Minecraft accessible"
    minecraft_response=$(curl -s --connect-timeout 15 "$MINECRAFT_URL/health" 2>/dev/null)
    echo "Réponse: $minecraft_response"
else
    print_error "Serveur Minecraft non accessible"
    print_status "Test avec timeout plus long..."
    if curl -s --connect-timeout 30 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
        print_warning "Serveur Minecraft accessible avec timeout long"
        minecraft_response=$(curl -s --connect-timeout 30 "$MINECRAFT_URL/health" 2>/dev/null)
        echo "Réponse: $minecraft_response"
    else
        print_error "Serveur Minecraft complètement inaccessible"
    fi
fi

# Test des autres endpoints Minecraft
print_status "Test des autres endpoints Minecraft..."
endpoints=("/api/tools" "/.well-known/mcp-config" "/mcp")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de $endpoint..."
    if curl -s --connect-timeout 10 "$MINECRAFT_URL$endpoint" >/dev/null 2>&1; then
        print_success "$endpoint: Accessible"
    else
        print_error "$endpoint: Non accessible"
    fi
done

echo ""
print_status "=== 4. ANALYSE DES PROBLÈMES ==="

# Analyser les problèmes
print_status "Problèmes identifiés:"

if curl -s --connect-timeout 10 "$HUB_URL/api/servers" | grep -q "minecraft\|Minecraft\|MCPC"; then
    print_success "✅ Serveur Minecraft détecté par le hub central"
else
    print_error "❌ Serveur Minecraft NON détecté par le hub central"
    print_status "Cause possible: Configuration du hub central non mise à jour"
fi

if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "✅ Serveur Minecraft opérationnel"
else
    print_error "❌ Serveur Minecraft non opérationnel"
    print_status "Cause possible: Serveur en cours de redéploiement ou arrêté"
fi

echo ""
print_status "=== 5. SOLUTIONS RECOMMANDÉES ==="

print_status "1. Si le serveur Minecraft est non opérationnel:"
print_status "   - Contacter le développeur du serveur Minecraft"
print_status "   - Vérifier le déploiement sur Railway"
print_status "   - Redémarrer le serveur si nécessaire"

print_status "2. Si le serveur Minecraft est opérationnel mais non détecté:"
print_status "   - Mettre à jour la configuration du hub central public"
print_status "   - Ajouter le serveur Minecraft à la configuration"
print_status "   - Redémarrer le hub central"

print_status "3. Solution temporaire:"
print_status "   - Utiliser le serveur Supabase uniquement"
print_status "   - Accéder directement au serveur Minecraft"
print_status "   - Utiliser le mode standalone local"

echo ""
print_status "=== 6. COMMANDES DE DEBUG ==="

print_status "Test manuel des serveurs:"
print_status "curl -s $HUB_URL/health"
print_status "curl -s $SUPABASE_URL/health"
print_status "curl -s $MINECRAFT_URL/health"

print_status "Vérification des serveurs détectés:"
print_status "curl -s $HUB_URL/api/servers"

print_status "Test avec timeout long:"
print_status "curl -s --connect-timeout 30 $MINECRAFT_URL/health"

echo ""
print_status "=== 7. RÉSUMÉ ==="

# Résumé final
hub_working=false
supabase_working=false
minecraft_working=false
minecraft_detected=false

if curl -s --connect-timeout 10 "$HUB_URL/health" >/dev/null 2>&1; then
    hub_working=true
fi

if curl -s --connect-timeout 10 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    supabase_working=true
fi

if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    minecraft_working=true
fi

if curl -s --connect-timeout 10 "$HUB_URL/api/servers" | grep -q "minecraft\|Minecraft\|MCPC"; then
    minecraft_detected=true
fi

print_status "Statut des services:"
if [ "$hub_working" = true ]; then
    print_success "✅ Hub Central: Opérationnel"
else
    print_error "❌ Hub Central: Non opérationnel"
fi

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

if [ "$minecraft_detected" = true ]; then
    print_success "✅ Serveur Minecraft: Détecté par le hub"
else
    print_error "❌ Serveur Minecraft: NON détecté par le hub"
fi

echo ""
if [ "$hub_working" = true ] && [ "$supabase_working" = true ]; then
    print_success "🎉 Le hub central et le serveur Supabase sont opérationnels !"
    if [ "$minecraft_working" = true ]; then
        print_warning "⚠️ Le serveur Minecraft est opérationnel mais non intégré au hub"
    else
        print_warning "⚠️ Le serveur Minecraft n'est pas opérationnel"
    fi
else
    print_error "❌ Problèmes détectés avec les services principaux"
fi

exit 0
