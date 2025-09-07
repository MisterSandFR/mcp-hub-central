#!/bin/bash

# Script de déploiement sur le serveur public
# Usage: ./deploy_to_public_server.sh

echo "🚀 Déploiement de la configuration sur le serveur public"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[DEPLOY]${NC} $1"
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

print_status "=== DÉPLOIEMENT SUR LE SERVEUR PUBLIC ==="

echo ""
print_status "=== 1. ÉTAPES DE DÉPLOIEMENT ==="

print_status "Sur le serveur public, exécutez les commandes suivantes:"

echo ""
print_status "1. 📥 Récupérer les dernières modifications:"
print_status "   cd /path/to/mcp-hub-central"
print_status "   git pull origin master"

echo ""
print_status "2. 🔧 Appliquer la nouvelle configuration:"
print_status "   # Option A: Utiliser le script de mise à jour"
print_status "   chmod +x update_hub_central_public.sh"
print_status "   ./update_hub_central_public.sh"
print_status ""
print_status "   # Option B: Appliquer manuellement la configuration"
print_status "   cp hub_central_update_config.json /path/to/mcp/config.json"

echo ""
print_status "3. 🔄 Redémarrer le service:"
print_status "   # Si service systemd:"
print_status "   sudo systemctl restart mcp-hub-central"
print_status ""
print_status "   # Si Docker Compose:"
print_status "   docker-compose down && docker-compose up -d"
print_status ""
print_status "   # Si processus Python direct:"
print_status "   pkill -f mcp_hub_central.py"
print_status "   nohup python mcp_hub_central.py > hub.log 2>&1 &"

echo ""
print_status "4. ✅ Vérifier le déploiement:"
print_status "   curl -s https://mcp.coupaul.fr/health"
print_status "   curl -s https://mcp.coupaul.fr/api/servers"
print_status "   curl -s https://mcp.coupaul.fr/api/tools"

echo ""
print_status "=== 2. FICHIERS À DÉPLOYER ==="

print_status "Fichiers créés et prêts pour le déploiement:"
print_success "✅ hub_central_update_config.json - Configuration MCP complète"
print_success "✅ update_hub_central_public.sh - Script de mise à jour"
print_success "✅ HUB_CENTRAL_UPDATE_GUIDE.md - Guide de mise à jour"
print_success "✅ mcp_servers_config.json - Configuration locale mise à jour"

echo ""
print_status "=== 3. CONFIGURATION À APPLIQUER ==="

print_status "La nouvelle configuration inclut:"
print_success "✅ Serveur Supabase MCP (existant)"
print_success "✅ Serveur Minecraft MCPC+ 1.6.4 (nouveau)"
print_success "✅ Endpoints complets (/api/servers, /api/tools)"
print_success "✅ Configuration multi-serveurs"

echo ""
print_status "=== 4. RÉSULTAT ATTENDU ==="

print_status "Après le déploiement, le hub central public devrait afficher:"
print_success "✅ 2 serveurs détectés (Supabase + Minecraft)"
print_success "✅ 51+ outils au total (47 Supabase + 4 Minecraft)"
print_success "✅ Serveur Minecraft visible dans l'interface"
print_success "✅ Informations correctes et à jour"

echo ""
print_status "=== 5. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier que le déploiement a réussi:"
print_status ""
print_status "# Test de base"
print_status "curl -s https://mcp.coupaul.fr/health"
print_status ""
print_status "# Vérifier les serveurs détectés"
print_status "curl -s https://mcp.coupaul.fr/api/servers | jq '.[].name'"
print_status ""
print_status "# Vérifier le nombre d'outils"
print_status "curl -s https://mcp.coupaul.fr/api/tools | jq 'length'"
print_status ""
print_status "# Vérifier la configuration MCP"
print_status "curl -s https://mcp.coupaul.fr/.well-known/mcp-config | jq '.mcpServers'"

echo ""
print_status "=== 6. EN CAS DE PROBLÈME ==="

print_status "Si le déploiement échoue:"
print_status "1. Vérifier les logs du service"
print_status "2. Vérifier que les fichiers sont bien déployés"
print_status "3. Vérifier la syntaxe JSON de la configuration"
print_status "4. Redémarrer le service"
print_status "5. Utiliser les serveurs individuels en attendant"

echo ""
print_status "=== 7. ROLLBACK (SI NÉCESSAIRE) ==="

print_status "Pour revenir à l'ancienne configuration:"
print_status "git checkout HEAD~1 -- config.json"
print_status "sudo systemctl restart mcp-hub-central"

echo ""
print_success "🎉 PRÊT POUR LE DÉPLOIEMENT !"
print_status "Exécutez 'git pull origin master' sur le serveur public"
print_status "puis suivez les étapes ci-dessus."

echo ""
print_status "=== COMMANDES RAPIDES POUR LE SERVEUR PUBLIC ==="
print_status "cd /path/to/mcp-hub-central"
print_status "git pull origin master"
print_status "chmod +x update_hub_central_public.sh"
print_status "./update_hub_central_public.sh"
print_status "sudo systemctl restart mcp-hub-central"
print_status "curl -s https://mcp.coupaul.fr/api/servers"

exit 0
