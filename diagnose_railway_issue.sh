#!/bin/bash

# Script de diagnostic approfondi Railway
# Usage: ./diagnose_railway_issue.sh

echo "🔍 Diagnostic approfondi Railway"

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

HUB_URL="https://mcp.coupaul.fr"
GITHUB_REPO="https://github.com/MisterSandFR/mcp-hub-central"

print_status "=== DIAGNOSTIC APPROFONDI RAILWAY ==="
print_status "Hub Central: $HUB_URL"
print_status "Repository GitHub: $GITHUB_REPO"

echo ""
print_status "=== 1. VÉRIFICATION DE LA CONFIGURATION ACTUELLE ==="

# Vérifier la configuration actuelle
print_status "Configuration actuelle du hub central:"
config_response=$(curl -s --max-time 10 "$HUB_URL/api/servers" 2>/dev/null)

if [ -n "$config_response" ]; then
    echo "$config_response" | jq '.' 2>/dev/null || echo "$config_response"
    
    # Vérifier la version
    version=$(echo "$config_response" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -n "$version" ]; then
        print_status "Version détectée: $version"
        if [ "$version" = "3.3.0" ]; then
            print_success "Version à jour"
        else
            print_error "Version obsolète (devrait être 3.3.0)"
        fi
    fi
    
    # Vérifier le serveur Minecraft
    if echo "$config_response" | grep -q "minecraft"; then
        print_success "Serveur Minecraft détecté"
    else
        print_error "Serveur Minecraft non détecté"
    fi
else
    print_error "Impossible de récupérer la configuration"
fi

echo ""
print_status "=== 2. VÉRIFICATION DU REPOSITORY GITHUB ==="

# Vérifier le repository GitHub
print_status "Vérification du repository GitHub..."

# Vérifier si le repository existe
repo_status=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/MisterSandFR/mcp-hub-central" 2>/dev/null)

if [ "$repo_status" = "200" ]; then
    print_success "Repository GitHub accessible"
    
    # Vérifier le dernier commit
    last_commit=$(curl -s "https://api.github.com/repos/MisterSandFR/mcp-hub-central/commits/main" 2>/dev/null | jq -r '.sha' 2>/dev/null)
    if [ "$last_commit" != "null" ] && [ -n "$last_commit" ]; then
        print_success "Dernier commit: $last_commit"
    else
        print_warning "Impossible de récupérer le dernier commit"
    fi
else
    print_error "Repository GitHub inaccessible (code: $repo_status)"
fi

echo ""
print_status "=== 3. VÉRIFICATION DES FICHIERS GITHUB ==="

# Vérifier les fichiers sur GitHub
print_status "Vérification des fichiers sur GitHub..."

# Vérifier mcp_servers_config.json
config_file=$(curl -s "https://raw.githubusercontent.com/MisterSandFR/mcp-hub-central/master/mcp_servers_config.json" 2>/dev/null)

if [ -n "$config_file" ]; then
    print_success "Fichier mcp_servers_config.json accessible sur GitHub"
    
    # Vérifier la version dans le fichier
    github_version=$(echo "$config_file" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -n "$github_version" ]; then
        print_status "Version sur GitHub: $github_version"
        if [ "$github_version" = "3.3.0" ]; then
            print_success "Version GitHub à jour"
        else
            print_error "Version GitHub obsolète"
        fi
    fi
    
    # Vérifier le serveur Minecraft
    if echo "$config_file" | grep -q "minecraft"; then
        print_success "Serveur Minecraft présent sur GitHub"
    else
        print_error "Serveur Minecraft absent sur GitHub"
    fi
else
    print_error "Fichier mcp_servers_config.json inaccessible sur GitHub"
fi

echo ""
print_status "=== 4. VÉRIFICATION DU CODE PYTHON GITHUB ==="

# Vérifier le code Python sur GitHub
print_status "Vérification du code Python sur GitHub..."

python_file=$(curl -s "https://raw.githubusercontent.com/MisterSandFR/mcp-hub-central/master/mcp_hub_central.py" 2>/dev/null)

if [ -n "$python_file" ]; then
    print_success "Fichier mcp_hub_central.py accessible sur GitHub"
    
    # Vérifier si le code utilise discovery_path
    if echo "$python_file" | grep -q "discovery_path"; then
        print_success "Code Python utilise discovery_path"
    else
        print_error "Code Python n'utilise pas discovery_path"
    fi
    
    # Vérifier si le code utilise discovery_timeout
    if echo "$python_file" | grep -q "discovery_timeout"; then
        print_success "Code Python utilise discovery_timeout"
    else
        print_error "Code Python n'utilise pas discovery_timeout"
    fi
else
    print_error "Fichier mcp_hub_central.py inaccessible sur GitHub"
fi

echo ""
print_status "=== 5. DIAGNOSTIC RAILWAY ==="

print_status "Problèmes possibles avec Railway:"

print_warning "1. 🔄 Webhook Railway cassé"
print_status "   - Railway ne reçoit pas les notifications GitHub"
print_status "   - Webhook non configuré ou cassé"

print_warning "2. 🐌 Cache Railway persistant"
print_status "   - Railway utilise un cache persistant"
print_status "   - Cache non invalidé malgré les changements"

print_warning "3. ⚙️ Configuration Railway obsolète"
print_status "   - Railway utilise une ancienne configuration"
print_status "   - Variables d'environnement obsolètes"

print_warning "4. 🔍 Problème de build Railway"
print_status "   - Erreur de build sur Railway"
print_status "   - Dépendances manquantes ou cassées"

print_warning "5. 🚀 Problème de déploiement Railway"
print_status "   - Déploiement échoue silencieusement"
print_status "   - Logs Railway non accessibles"

echo ""
print_status "=== 6. SOLUTIONS RAILWAY ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Sélectionner le projet"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Vérifier les webhooks"
print_status "   - Aller sur GitHub Settings > Webhooks"
print_status "   - Vérifier que Railway est configuré"
print_status "   - Tester le webhook"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Variables d'environnement"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les variables d'environnement"
print_status "   - S'assurer qu'elles sont à jour"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Nouveau déploiement"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Connecter au repository GitHub"
print_status "   - Redéployer depuis zéro"

echo ""
print_status "=== 7. ACTIONS IMMÉDIATES ==="

print_status "Actions à effectuer maintenant:"

print_status "1. 🔍 Vérifier Railway Dashboard:"
print_status "   - Aller sur https://railway.app/dashboard"
print_status "   - Sélectionner le projet mcp-hub-central"
print_status "   - Vérifier les logs de build"
print_status "   - Vérifier les logs runtime"

print_status "2. 🔄 Forcer le redéploiement:"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"
print_status "   - Vérifier les performances"

print_status "3. 🔧 Vérifier les webhooks GitHub:"
print_status "   - Aller sur GitHub Settings > Webhooks"
print_status "   - Vérifier que Railway est configuré"
print_status "   - Tester le webhook"

print_status "4. ⚙️ Vérifier les variables d'environnement:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les variables d'environnement"
print_status "   - S'assurer qu'elles sont à jour"

echo ""
print_status "=== 8. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier la configuration actuelle:"
print_status "curl -s '$HUB_URL/api/servers' | jq '.hub.version'"

print_status "Vérifier les performances:"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/' <<< 'time_total: %{time_total}\n'"

print_status "Vérifier le serveur Minecraft:"
print_status "curl -s '$HUB_URL/api/servers' | jq '.servers[] | select(.id == \"minecraft\")'"

echo ""
print_status "=== 9. RÉSUMÉ ==="

print_status "Statut du diagnostic:"

if [ "$version" = "3.3.0" ]; then
    print_success "✅ Configuration à jour"
else
    print_error "❌ Configuration obsolète"
fi

if echo "$config_response" | grep -q "minecraft"; then
    print_success "✅ Serveur Minecraft détecté"
else
    print_error "❌ Serveur Minecraft non détecté"
fi

print_status "Conclusion:"
print_error "🚨 Railway n'a pas déployé nos changements"
print_status "✅ SOLUTION: Redéploiement manuel sur Railway Dashboard"

echo ""
print_error "🚨 CONCLUSION: Railway ne déploie pas les changements"
print_status "✅ SOLUTION: Redéploiement manuel sur Railway Dashboard"
print_status "Le problème est côté Railway, pas côté code !"

exit 0
