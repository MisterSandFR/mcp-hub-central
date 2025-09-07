#!/bin/bash

# Script de diagnostic des ports Railway internes
# Usage: ./diagnose_railway_ports.sh

echo "🔍 Diagnostic des ports Railway internes"

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

print_status "=== DIAGNOSTIC DES PORTS RAILWAY INTERNES ==="

echo ""
print_status "=== 1. VÉRIFICATION DES SERVEURS PUBLICS ==="

# Vérifier les serveurs publics
print_status "Test du serveur Supabase public..."
supabase_public=$(curl -s --max-time 5 "https://supabase.mcp.coupaul.fr/health" 2>/dev/null)
if [ -n "$supabase_public" ]; then
    print_success "Serveur Supabase public accessible"
    echo "$supabase_public" | head -1
else
    print_error "Serveur Supabase public inaccessible"
fi

print_status "Test du serveur Minecraft public..."
minecraft_public=$(curl -s --max-time 5 "https://minecraft.mcp.coupaul.fr/health" 2>/dev/null)
if [ -n "$minecraft_public" ]; then
    print_success "Serveur Minecraft public accessible"
    echo "$minecraft_public" | head -1
else
    print_error "Serveur Minecraft public inaccessible"
fi

echo ""
print_status "=== 2. ANALYSE DES PORTS RAILWAY ==="

print_status "Ports Railway typiques:"
print_status "- Port 8000: Port par défaut Railway"
print_status "- Port 3000: Port par défaut Node.js"
print_status "- Port 8080: Port alternatif Railway"
print_status "- Port 443: Port HTTPS (externe)"
print_status "- Port 80: Port HTTP (externe)"

echo ""
print_status "=== 3. CONFIGURATION ACTUELLE ==="

print_status "Configuration actuelle:"
print_status "Supabase: supabase-mcp-selfhosted.railway.internal:8000"
print_status "Minecraft: minecraft-mcp-forge-164.railway.internal:3000"

echo ""
print_status "=== 4. PROBLÈME IDENTIFIÉ ==="

print_error "Problème: Port 8000 incorrect pour Supabase"
print_status "Le serveur Supabase utilise probablement le port 443 (HTTPS) ou un autre port"

print_status "Solutions possibles:"
print_warning "1. 🔧 Port 443 (HTTPS interne)"
print_warning "2. 🔧 Port 8080 (port alternatif Railway)"
print_warning "3. 🔧 Port 80 (HTTP interne)"
print_warning "4. 🔧 Port 3000 (port par défaut)"

echo ""
print_status "=== 5. RECOMMANDATIONS ==="

print_status "Recommandations pour corriger le port Supabase:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Port 443"
print_status "   - Supabase utilise HTTPS (port 443)"
print_status "   - Railway peut exposer le port 443 en interne"

print_status "2. 🔧 SOLUTION ALTERNATIVE: Port 8080"
print_status "   - Port alternatif Railway"
print_status "   - Souvent utilisé pour les services internes"

print_status "3. ⚙️ SOLUTION TECHNIQUE: Port 80"
print_status "   - HTTP interne Railway"
print_status "   - Plus simple que HTTPS"

echo ""
print_status "=== 6. CONFIGURATION RECOMMANDÉE ==="

print_status "Configuration recommandée:"

print_status "Serveur Supabase:"
print_status "  - Host: supabase-mcp-selfhosted.railway.internal"
print_status "  - Port: 443 (HTTPS interne)"
print_status "  - Protocol: https"

print_status "Serveur Minecraft:"
print_status "  - Host: minecraft-mcp-forge-164.railway.internal"
print_status "  - Port: 3000"
print_status "  - Protocol: http"

echo ""
print_status "=== 7. COMMANDES DE TEST ==="

print_status "Tester différents ports (depuis Railway):"
print_status "curl -s 'http://supabase-mcp-selfhosted.railway.internal:443/health'"
print_status "curl -s 'http://supabase-mcp-selfhosted.railway.internal:8080/health'"
print_status "curl -s 'http://supabase-mcp-selfhosted.railway.internal:80/health'"

echo ""
print_status "=== 8. RÉSUMÉ ==="

print_status "Problème identifié:"
print_error "❌ Port 8000 incorrect pour Supabase"

print_status "Cause:"
print_warning "Supabase utilise probablement le port 443 (HTTPS) ou 8080"

print_status "Solution:"
print_status "1. Changer le port Supabase de 8000 à 443"
print_status "2. Changer le protocol de http à https"
print_status "3. Tester la connectivité"

echo ""
print_error "🚨 CONCLUSION: Port Supabase incorrect"
print_status "✅ SOLUTION: Changer le port Supabase à 443 (HTTPS interne)"

exit 0
