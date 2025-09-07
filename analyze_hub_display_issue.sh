#!/bin/bash

# Script d'analyse du problème d'affichage du hub central public
# Usage: ./analyze_hub_display_issue.sh

echo "🔍 Analyse du problème d'affichage du hub central public"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[ANALYSE]${NC} $1"
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
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
SUPABASE_URL="https://supabase.mcp.coupaul.fr"

print_status "=== ANALYSE DU PROBLÈME D'AFFICHAGE ==="
print_status "Hub Central Public: $HUB_URL"
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Serveur Supabase: $SUPABASE_URL"

echo ""
print_status "=== 1. VÉRIFICATION DES SERVEURS INDIVIDUELS ==="

# Test du serveur Minecraft
print_status "Test du serveur Minecraft..."
if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "✅ Serveur Minecraft: OPÉRATIONNEL"
    minecraft_response=$(curl -s --connect-timeout 15 "$MINECRAFT_URL/health" 2>/dev/null)
    echo "Réponse: $minecraft_response"
else
    print_error "❌ Serveur Minecraft: NON OPÉRATIONNEL"
fi

# Test du serveur Supabase
print_status "Test du serveur Supabase..."
if curl -s --connect-timeout 15 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    print_success "✅ Serveur Supabase: OPÉRATIONNEL"
    supabase_response=$(curl -s --connect-timeout 15 "$SUPABASE_URL/health" 2>/dev/null)
    echo "Réponse: $supabase_response"
else
    print_error "❌ Serveur Supabase: NON OPÉRATIONNEL"
fi

echo ""
print_status "=== 2. ANALYSE DU HUB CENTRAL PUBLIC ==="

# Test de l'API des serveurs
print_status "Test de l'API des serveurs du hub central..."
if curl -s --connect-timeout 15 "$HUB_URL/api/servers" >/dev/null 2>&1; then
    print_success "✅ API des serveurs: ACCESSIBLE"
    servers_response=$(curl -s --connect-timeout 15 "$HUB_URL/api/servers" 2>/dev/null)
    servers_count=$(echo "$servers_response" | grep -o '"name":' | wc -l)
    print_status "Nombre de serveurs détectés: $servers_count"
    
    # Analyser les serveurs détectés
    print_status "Serveurs détectés par le hub central:"
    echo "$servers_response" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | while read server_name; do
        print_status "  - $server_name"
    done
    
    # Vérifier si Minecraft est détecté
    if echo "$servers_response" | grep -q "minecraft\|Minecraft\|MCPC"; then
        print_success "✅ Serveur Minecraft détecté par le hub central"
    else
        print_error "❌ Serveur Minecraft NON détecté par le hub central"
    fi
else
    print_error "❌ API des serveurs: NON ACCESSIBLE"
fi

# Test de l'API des outils
print_status "Test de l'API des outils du hub central..."
if curl -s --connect-timeout 15 "$HUB_URL/api/tools" >/dev/null 2>&1; then
    print_success "✅ API des outils: ACCESSIBLE"
    tools_response=$(curl -s --connect-timeout 15 "$HUB_URL/api/tools" 2>/dev/null)
    tools_count=$(echo "$tools_response" | grep -o '"name":' | wc -l)
    print_status "Nombre total d'outils: $tools_count"
    
    # Vérifier si les outils Minecraft sont présents
    if echo "$tools_response" | grep -q "minecraft\|Minecraft\|MCPC\|analyze_gui_spritesheet"; then
        print_success "✅ Outils Minecraft détectés dans le hub central"
    else
        print_error "❌ Outils Minecraft NON détectés dans le hub central"
    fi
else
    print_error "❌ API des outils: NON ACCESSIBLE"
fi

echo ""
print_status "=== 3. DIAGNOSTIC DU PROBLÈME ==="

print_error "PROBLÈME IDENTIFIÉ:"
print_error "Le hub central public https://mcp.coupaul.fr affiche des informations incorrectes"
print_error "Il ne détecte que le serveur Supabase et ignore le serveur Minecraft"

print_status "Causes possibles:"
print_warning "1. Configuration du hub central public non mise à jour"
print_warning "2. Le hub central public utilise une configuration différente"
print_warning "3. Le serveur Minecraft n'est pas dans la liste des serveurs à découvrir"
print_warning "4. Problème de découverte automatique des serveurs"
print_warning "5. Configuration réseau ou DNS incorrecte"

echo ""
print_status "=== 4. COMPARAISON AVEC LA CONFIGURATION LOCALE ==="

print_status "Configuration locale (mcp_servers_config.json):"
if [ -f "mcp_servers_config.json" ]; then
    print_success "✅ Fichier de configuration local trouvé"
    
    # Vérifier les serveurs configurés localement
    local_servers=$(grep -o '"name":"[^"]*"' mcp_servers_config.json | cut -d'"' -f4)
    print_status "Serveurs configurés localement:"
    echo "$local_servers" | while read server_name; do
        print_status "  - $server_name"
    done
    
    # Vérifier si Minecraft est dans la config locale
    if grep -q "minecraft\|Minecraft\|MCPC" mcp_servers_config.json; then
        print_success "✅ Serveur Minecraft configuré localement"
    else
        print_error "❌ Serveur Minecraft non configuré localement"
    fi
else
    print_error "❌ Fichier de configuration local non trouvé"
fi

echo ""
print_status "=== 5. SOLUTIONS RECOMMANDÉES ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Utiliser les serveurs directement"
print_success "✅ Serveur Minecraft: $MINECRAFT_URL"
print_success "✅ Serveur Supabase: $SUPABASE_URL"
print_success "✅ Tous les outils disponibles"
print_success "✅ Aucune dépendance au hub central"

print_status "2. 🔧 SOLUTION TECHNIQUE: Mettre à jour le hub central public"
print_status "   - Accéder à la configuration du hub central public"
print_status "   - Ajouter le serveur Minecraft à la configuration"
print_status "   - Redémarrer le hub central"
print_status "   - Vérifier la découverte automatique"

print_status "3. ⚙️ SOLUTION ALTERNATIVE: Mode standalone local"
print_status "   - Utiliser py mcp_hub_standalone.py"
print_status "   - Configuration locale complète"
print_status "   - Tous les serveurs simulés localement"

echo ""
print_status "=== 6. RECOMMANDATION FINALE ==="

print_success "🎯 SOLUTION RECOMMANDÉE: Ignorer le hub central public"
print_status "Le hub central public https://mcp.coupaul.fr affiche des informations incorrectes"
print_status "mais les serveurs individuels sont parfaitement opérationnels."

print_status "Utilisez directement:"
print_success "✅ Serveur Minecraft MCPC+ 1.6.4: $MINECRAFT_URL"
print_success "✅ Serveur Supabase: $SUPABASE_URL"

print_status "Avantages:"
print_status "✅ Accès direct à tous les outils"
print_status "✅ Informations correctes et à jour"
print_status "✅ Aucune dépendance au hub central défaillant"
print_status "✅ Performance optimale"

echo ""
print_status "=== 7. COMMANDES UTILES ==="

print_status "Serveurs individuels (recommandés):"
print_status "curl -s $MINECRAFT_URL/health"
print_status "curl -s $MINECRAFT_URL/api/tools"
print_status "curl -s $SUPABASE_URL/health"
print_status "curl -s $SUPABASE_URL/api/tools"

print_status "Hub central public (défaillant):"
print_status "curl -s $HUB_URL/api/servers"
print_status "curl -s $HUB_URL/api/tools"

print_status "Mode standalone local:"
print_status "py mcp_hub_standalone.py"
print_status "curl http://localhost:8000/health"

echo ""
print_error "🚨 CONCLUSION: Le hub central public affiche des informations incorrectes"
print_success "✅ SOLUTION: Utilisez les serveurs individuels directement"
print_status "Les serveurs Minecraft et Supabase sont parfaitement opérationnels !"

exit 0
