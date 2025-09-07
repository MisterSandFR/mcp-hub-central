#!/bin/bash

# Script de vérification du déploiement Railway
# Usage: ./verify_railway_deployment.sh

echo "🚀 Vérification du déploiement Railway"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[RAILWAY]${NC} $1"
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

print_status "=== VÉRIFICATION DU DÉPLOIEMENT RAILWAY ==="
print_status "Hub Central: $HUB_URL"
print_status "Repository GitHub: $GITHUB_REPO"

echo ""
print_status "=== 1. VÉRIFICATION DU REPOSITORY GITHUB ==="

# Vérifier le dernier commit sur GitHub
print_status "Vérification du dernier commit sur GitHub..."
last_commit=$(curl -s "https://api.github.com/repos/MisterSandFR/mcp-hub-central/commits/main" | jq -r '.sha' 2>/dev/null)

if [ "$last_commit" != "null" ] && [ -n "$last_commit" ]; then
    print_success "Dernier commit GitHub: $last_commit"
    
    # Vérifier la date du commit
    commit_date=$(curl -s "https://api.github.com/repos/MisterSandFR/mcp-hub-central/commits/main" | jq -r '.commit.committer.date' 2>/dev/null)
    print_status "Date du commit: $commit_date"
else
    print_error "Impossible de récupérer le dernier commit GitHub"
fi

echo ""
print_status "=== 2. VÉRIFICATION DU HUB CENTRAL ==="

# Test de performance du hub central
print_status "Test de performance du hub central..."
hub_perf=$(curl -w "@-" -o /dev/null -s --max-time 15 "$HUB_URL/" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$hub_perf"

# Analyser les temps
time_total=$(echo "$hub_perf" | grep "time_total:" | awk '{print $2}')
time_starttransfer=$(echo "$hub_perf" | grep "time_starttransfer:" | awk '{print $2}')

print_status "Analyse des temps de réponse:"
print_status "Temps total: ${time_total}s"
print_status "Temps jusqu'au premier byte: ${time_starttransfer}s"

# Évaluer les performances
if (( $(echo "$time_total < 1.0" | bc -l 2>/dev/null || echo "0") )); then
    print_success "Performance excellente (< 1s)"
elif (( $(echo "$time_total < 3.0" | bc -l 2>/dev/null || echo "0") )); then
    print_warning "Performance acceptable (1-3s)"
elif (( $(echo "$time_total < 5.0" | bc -l 2>/dev/null || echo "0") )); then
    print_warning "Performance lente (3-5s)"
else
    print_error "Performance très lente (> 5s)"
fi

echo ""
print_status "=== 3. VÉRIFICATION DES ENDPOINTS ==="

# Test des endpoints spécifiques
endpoints=("/health" "/api/servers" "/api/tools")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de $endpoint..."
    
    # Test avec timeout court
    response=$(curl -s -w "%{http_code}" -o /dev/null --max-time 10 "$HUB_URL$endpoint")
    
    if [ "$response" = "200" ]; then
        print_success "$endpoint: OK (200)"
    elif [ "$response" = "000" ]; then
        print_error "$endpoint: Timeout ou erreur de connexion"
    else
        print_warning "$endpoint: Code $response"
    fi
done

echo ""
print_status "=== 4. VÉRIFICATION DE LA CONFIGURATION ==="

# Vérifier si la configuration est à jour
print_status "Vérification de la configuration..."
config_response=$(curl -s --max-time 10 "$HUB_URL/api/servers")

if echo "$config_response" | grep -q "3.3.0"; then
    print_success "Configuration à jour (version 3.3.0 détectée)"
elif echo "$config_response" | grep -q "3.2.0"; then
    print_warning "Configuration partiellement à jour (version 3.2.0)"
elif echo "$config_response" | grep -q "3.1.0"; then
    print_error "Configuration obsolète (version 3.1.0)"
else
    print_error "Impossible de déterminer la version"
fi

echo ""
print_status "=== 5. VÉRIFICATION DES SERVEURS ==="

# Vérifier le statut des serveurs
print_status "Vérification du statut des serveurs..."
servers_response=$(curl -s --max-time 10 "$HUB_URL/api/servers")

if echo "$servers_response" | grep -q "minecraft"; then
    print_success "Serveur Minecraft détecté dans la configuration"
else
    print_error "Serveur Minecraft non détecté"
fi

if echo "$servers_response" | grep -q "supabase"; then
    print_success "Serveur Supabase détecté dans la configuration"
else
    print_error "Serveur Supabase non détecté"
fi

echo ""
print_status "=== 6. DIAGNOSTIC RAILWAY ==="

print_status "Problèmes possibles avec Railway:"

print_warning "1. 🔄 Déploiement en cours"
print_status "   - Railway peut prendre 2-5 minutes pour déployer"
print_status "   - Vérifier les logs Railway pour les erreurs"

print_warning "2. 🐌 Cache Railway"
print_status "   - Railway peut mettre du temps à invalider le cache"
print_status "   - Forcer un redéploiement peut être nécessaire"

print_warning "3. ⚙️ Configuration Railway"
print_status "   - Variables d'environnement non mises à jour"
print_status "   - Build cache non invalidé"

print_warning "4. 🔍 Problème de build"
print_status "   - Erreur de build sur Railway"
print_status "   - Dépendances manquantes"

echo ""
print_status "=== 7. SOLUTIONS RAILWAY ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Forcer le redéploiement"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Cliquer sur 'Redeploy'"
print_status "   - Attendre 2-3 minutes"

print_status "2. 🔧 SOLUTION TECHNIQUE: Vérifier les logs"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Vérifier les logs de build et runtime"
print_status "   - Chercher les erreurs"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Variables d'environnement"
print_status "   - Vérifier les variables d'environnement Railway"
print_status "   - S'assurer qu'elles sont à jour"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Plan Railway"
print_status "   - Vérifier le plan Railway"
print_status "   - S'assurer que les ressources sont suffisantes"

echo ""
print_status "=== 8. COMMANDES DE VÉRIFICATION ==="

print_status "Vérifier le déploiement Railway:"
print_status "1. Aller sur https://railway.app/dashboard"
print_status "2. Sélectionner le projet mcp-hub-central"
print_status "3. Vérifier les logs de build"
print_status "4. Cliquer sur 'Redeploy' si nécessaire"

print_status "Vérifier les performances:"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/' <<< 'time_total: %{time_total}\n'"

print_status "Vérifier la configuration:"
print_status "curl -s '$HUB_URL/api/servers' | jq '.'"

echo ""
print_status "=== 9. RÉSUMÉ ==="

print_status "Statut du déploiement:"

if [ "$time_total" != "" ]; then
    if (( $(echo "$time_total < 3.0" | bc -l 2>/dev/null || echo "0") )); then
        print_success "✅ Déploiement réussi - Performances bonnes"
    else
        print_warning "⚠️ Déploiement partiel - Performances lentes"
    fi
else
    print_error "❌ Déploiement échoué - Hub inaccessible"
fi

print_status "Actions recommandées:"
print_status "1. Vérifier les logs Railway"
print_status "2. Forcer un redéploiement si nécessaire"
print_status "3. Attendre 2-3 minutes après redéploiement"
print_status "4. Tester à nouveau les performances"

echo ""
print_error "🚨 CONCLUSION: Vérification du déploiement Railway nécessaire"
print_status "✅ SOLUTION: Forcer le redéploiement sur Railway Dashboard"

exit 0
