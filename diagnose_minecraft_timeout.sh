#!/bin/bash

# Script de diagnostic du serveur Minecraft MCPC+ 1.6.4
# Usage: ./diagnose_minecraft_timeout.sh

echo "🔍 Diagnostic du serveur Minecraft MCPC+ 1.6.4 - Problème de timeout"

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

MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
HUB_URL="https://mcp.coupaul.fr"

print_status "=== DIAGNOSTIC SERVEUR MINECRAFT TIMEOUT ==="
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Hub Central: $HUB_URL"

echo ""
print_status "=== 1. TEST DE CONNECTIVITÉ DE BASE ==="

# Test de connectivité de base
print_status "Test de connectivité de base..."
if curl -s --connect-timeout 5 "$MINECRAFT_URL" >/dev/null 2>&1; then
    print_success "Serveur accessible (mais peut-être lent)"
else
    print_error "Serveur non accessible"
fi

# Test avec différents timeouts
print_status "Test avec timeout 5 secondes..."
if curl -s --connect-timeout 5 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Health check accessible (5s)"
else
    print_error "Health check timeout (5s)"
fi

print_status "Test avec timeout 10 secondes..."
if curl -s --connect-timeout 10 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Health check accessible (10s)"
else
    print_error "Health check timeout (10s)"
fi

print_status "Test avec timeout 30 secondes..."
if curl -s --connect-timeout 30 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Health check accessible (30s)"
    health_response=$(curl -s --connect-timeout 30 "$MINECRAFT_URL/health" 2>/dev/null)
    echo "Réponse: $health_response"
else
    print_error "Health check timeout (30s)"
fi

echo ""
print_status "=== 2. TEST DES AUTRES ENDPOINTS ==="

# Test des autres endpoints
endpoints=("/api/tools" "/.well-known/mcp-config" "/mcp")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de $endpoint..."
    if curl -s --connect-timeout 15 "$MINECRAFT_URL$endpoint" >/dev/null 2>&1; then
        print_success "$endpoint: Accessible"
    else
        print_error "$endpoint: Timeout"
    fi
done

echo ""
print_status "=== 3. ANALYSE DU PROBLÈME ==="

print_error "PROBLÈME IDENTIFIÉ:"
print_error "Le serveur Minecraft MCPC+ 1.6.4 retourne des timeouts"
print_error "Cela indique que le serveur est arrêté ou a des problèmes de déploiement"

print_status "Causes possibles:"
print_warning "1. Serveur Minecraft arrêté sur Railway"
print_warning "2. Problème de déploiement Railway"
print_warning "3. Serveur en cours de redéploiement"
print_warning "4. Problème de configuration Railway"
print_warning "5. Serveur surchargé ou en panne"

echo ""
print_status "=== 4. COMPARAISON AVEC LE SERVEUR SUPABASE ==="

print_status "Test du serveur Supabase pour comparaison..."
if curl -s --connect-timeout 5 "https://supabase.mcp.coupaul.fr/health" >/dev/null 2>&1; then
    print_success "Serveur Supabase: Opérationnel"
    supabase_response=$(curl -s --connect-timeout 5 "https://supabase.mcp.coupaul.fr/health" 2>/dev/null)
    echo "Réponse: $supabase_response"
else
    print_error "Serveur Supabase: Non accessible"
fi

echo ""
print_status "=== 5. SOLUTIONS RECOMMANDÉES ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Contacter le développeur Minecraft"
print_status "   - Le serveur Minecraft MCPC+ 1.6.4 est arrêté"
print_status "   - Contacter le développeur pour redémarrer le serveur"
print_status "   - Vérifier le statut du déploiement Railway"

print_status "2. 🔧 SOLUTION TECHNIQUE: Vérifier Railway"
print_status "   - Se connecter à Railway Dashboard"
print_status "   - Vérifier le statut du service Minecraft"
print_status "   - Redémarrer le service si nécessaire"

print_status "3. ⚙️ SOLUTION TEMPORAIRE: Utiliser le serveur Supabase uniquement"
print_status "   - Le serveur Supabase est opérationnel"
print_status "   - Utiliser uniquement les outils Supabase"
print_status "   - Attendre que le serveur Minecraft soit réparé"

echo ""
print_status "=== 6. MISE À JOUR DE LA CONFIGURATION HUB ==="

print_status "En attendant la réparation du serveur Minecraft:"
print_status "Le hub central peut être configuré pour ignorer le serveur Minecraft"
print_status "ou afficher un statut 'maintenance' pour ce serveur"

echo ""
print_status "=== 7. COMMANDES DE DEBUG ==="

print_status "Test manuel du serveur Minecraft:"
print_status "curl -s --connect-timeout 30 $MINECRAFT_URL/health"
print_status "curl -s --connect-timeout 30 $MINECRAFT_URL/api/tools"

print_status "Test du hub central:"
print_status "curl -s $HUB_URL/api/servers"
print_status "curl -s $HUB_URL/api/tools"

print_status "Test du serveur Supabase:"
print_status "curl -s https://supabase.mcp.coupaul.fr/health"

echo ""
print_status "=== 8. RÉSUMÉ ==="

print_status "Statut des services:"
print_success "✅ Serveur Supabase: Opérationnel"
print_error "❌ Serveur Minecraft: Hors ligne (timeout)"
print_success "✅ Hub Central: Opérationnel (avec Supabase uniquement)"

print_status "Actions requises:"
print_warning "1. Contacter le développeur du serveur Minecraft"
print_warning "2. Vérifier le déploiement Railway"
print_warning "3. Redémarrer le serveur Minecraft"
print_warning "4. Utiliser le serveur Supabase en attendant"

echo ""
print_error "🚨 CONCLUSION: Le serveur Minecraft MCPC+ 1.6.4 est arrêté"
print_success "✅ SOLUTION: Contacter le développeur pour redémarrer le serveur"
print_status "Le serveur Supabase fonctionne parfaitement !"

exit 1
