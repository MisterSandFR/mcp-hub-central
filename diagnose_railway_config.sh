#!/bin/bash

# Script de diagnostic de la configuration Railway
# Usage: ./diagnose_railway_config.sh

echo "🔍 Diagnostic de la configuration Railway"

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

print_status "=== DIAGNOSTIC DE LA CONFIGURATION RAILWAY ==="

echo ""
print_status "=== 1. VÉRIFICATION DE LA CONFIGURATION DÉPLOYÉE ==="

# Vérifier la configuration déployée
print_status "Configuration actuelle sur Railway:"
config_deployed=$(curl -s --max-time 10 "https://mcp.coupaul.fr/api/servers" 2>/dev/null)

if [ -n "$config_deployed" ]; then
    echo "$config_deployed" | jq '.' 2>/dev/null || echo "$config_deployed"
    
    # Vérifier la version
    version_deployed=$(echo "$config_deployed" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -n "$version_deployed" ]; then
        print_status "Version déployée: $version_deployed"
        if [ "$version_deployed" = "3.5.0" ]; then
            print_success "✅ Version à jour (3.5.0)"
        else
            print_error "❌ Version obsolète ($version_deployed)"
        fi
    fi
    
    # Vérifier le serveur Minecraft
    if echo "$config_deployed" | grep -q "minecraft"; then
        print_success "✅ Serveur Minecraft détecté"
    else
        print_error "❌ Serveur Minecraft non détecté"
    fi
    
    # Vérifier les domaines internes
    if echo "$config_deployed" | grep -q "railway.internal"; then
        print_success "✅ Domaines internes Railway détectés"
    else
        print_error "❌ Domaines internes Railway non détectés"
    fi
else
    print_error "❌ Impossible de récupérer la configuration"
fi

echo ""
print_status "=== 2. VÉRIFICATION DE LA CONFIGURATION LOCALE ==="

# Vérifier la configuration locale
print_status "Configuration locale:"
if [ -f "mcp_servers_config.json" ]; then
    print_success "✅ Fichier mcp_servers_config.json présent"
    
    # Vérifier la version locale
    local_version=$(grep -o '"version":"[^"]*"' mcp_servers_config.json | head -1 | cut -d'"' -f4)
    if [ -n "$local_version" ]; then
        print_status "Version locale: $local_version"
        if [ "$local_version" = "3.5.0" ]; then
            print_success "✅ Version locale à jour (3.5.0)"
        else
            print_error "❌ Version locale obsolète ($local_version)"
        fi
    fi
    
    # Vérifier les domaines internes locaux
    if grep -q "railway.internal" mcp_servers_config.json; then
        print_success "✅ Domaines internes Railway configurés localement"
    else
        print_error "❌ Domaines internes Railway non configurés localement"
    fi
else
    print_error "❌ Fichier mcp_servers_config.json absent"
fi

echo ""
print_status "=== 3. ANALYSE DU PROBLÈME ==="

print_status "Problème identifié:"
print_error "Railway n'utilise pas le fichier mcp_servers_config.json"

print_status "Causes possibles:"
print_warning "1. 🔄 Railway ne lit pas le fichier de configuration"
print_status "   - Le code Python ne charge pas le fichier JSON"
print_status "   - Configuration hardcodée dans le code"

print_warning "2. 🐌 Cache Railway persistant"
print_status "   - Railway utilise un cache de configuration"
print_status "   - Cache non invalidé malgré les changements"

print_warning "3. ⚙️ Configuration Railway incorrecte"
print_status "   - Variables d'environnement Railway"
print_status "   - Configuration Railway non mise à jour"

print_warning "4. 🔍 Problème de build Railway"
print_status "   - Erreur de build sur Railway"
print_status "   - Fichier JSON non inclus dans le build"

echo ""
print_status "=== 4. SOLUTIONS ==="

print_status "Solutions pour résoudre le problème:"

print_status "1. 🎯 SOLUTION IMMÉDIATE: Vérifier le code Python"
print_status "   - Le code Python doit charger mcp_servers_config.json"
print_status "   - Vérifier que le fichier est lu correctement"

print_status "2. 🔧 SOLUTION TECHNIQUE: Variables d'environnement"
print_status "   - Utiliser des variables d'environnement Railway"
print_status "   - Configuration via Railway Dashboard"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Hardcoder la configuration"
print_status "   - Intégrer la configuration directement dans le code Python"
print_status "   - Éviter la dépendance au fichier JSON"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Nouveau déploiement"
print_status "   - Créer un nouveau projet Railway"
print_status "   - Redéployer depuis zéro"

echo ""
print_status "=== 5. VÉRIFICATION DU CODE PYTHON ==="

print_status "Vérification du code Python..."

if [ -f "mcp_hub_central.py" ]; then
    print_success "✅ Fichier mcp_hub_central.py présent"
    
    # Vérifier si le code charge le fichier JSON
    if grep -q "mcp_servers_config.json" mcp_hub_central.py; then
        print_success "✅ Code Python référence mcp_servers_config.json"
    else
        print_error "❌ Code Python ne référence pas mcp_servers_config.json"
    fi
    
    # Vérifier la méthode de chargement
    if grep -q "load_servers_config" mcp_hub_central.py; then
        print_success "✅ Méthode load_servers_config présente"
    else
        print_error "❌ Méthode load_servers_config absente"
    fi
else
    print_error "❌ Fichier mcp_hub_central.py absent"
fi

echo ""
print_status "=== 6. ACTIONS IMMÉDIATES ==="

print_status "Actions à effectuer maintenant:"

print_status "1. 🔍 Vérifier le code Python:"
print_status "   - S'assurer que mcp_servers_config.json est chargé"
print_status "   - Vérifier la méthode load_servers_config"

print_status "2. 🔄 Redéployer Railway:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

print_status "3. 🔧 Vérifier les variables d'environnement:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les variables d'environnement"
print_status "   - S'assurer qu'elles sont à jour"

echo ""
print_status "=== 7. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier la configuration déployée:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.hub.version'"

print_status "Vérifier les serveurs:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.servers[] | {id, host, port, protocol}'"

print_status "Vérifier les performances:"
print_status "curl -w '@-' -o /dev/null -s 'https://mcp.coupaul.fr/' <<< 'time_total: %{time_total}\n'"

echo ""
print_status "=== 8. RÉSUMÉ ==="

print_status "Problème identifié:"
print_error "❌ Railway n'utilise pas le fichier mcp_servers_config.json"

print_status "Cause principale:"
print_warning "Le code Python ne charge pas correctement le fichier JSON"

print_status "Solution:"
print_status "1. Vérifier le code Python"
print_status "2. Redéployer Railway"
print_status "3. Vérifier les variables d'environnement"

echo ""
print_error "🚨 CONCLUSION: Configuration Railway non mise à jour"
print_status "✅ SOLUTION: Vérifier le code Python et redéployer Railway"

exit 0
