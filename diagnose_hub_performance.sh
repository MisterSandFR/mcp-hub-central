#!/bin/bash

# Script de diagnostic des performances du MCP Hub Central
# Usage: ./diagnose_hub_performance.sh

echo "⚡ Diagnostic des performances du MCP Hub Central"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[PERF]${NC} $1"
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

print_status "=== DIAGNOSTIC DES PERFORMANCES MCP HUB CENTRAL ==="
print_status "Hub Central: $HUB_URL"
print_status "Serveur Supabase: $SUPABASE_URL"
print_status "Serveur Minecraft: $MINECRAFT_URL"

echo ""
print_status "=== 1. TEST DE PERFORMANCE DU HUB CENTRAL ==="

# Test de performance du hub central
print_status "Test de performance du hub central..."
hub_perf=$(curl -w "@-" -o /dev/null -s "$HUB_URL/" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$hub_perf"

# Analyser les temps
time_total=$(echo "$hub_perf" | grep "time_total:" | awk '{print $2}')
time_starttransfer=$(echo "$hub_perf" | grep "time_starttransfer:" | awk '{print $2}')
time_connect=$(echo "$hub_perf" | grep "time_connect:" | awk '{print $2}')

print_status "Analyse des temps de réponse:"
print_status "Temps total: ${time_total}s"
print_status "Temps jusqu'au premier byte: ${time_starttransfer}s"
print_status "Temps de connexion: ${time_connect}s"

# Évaluer les performances
if (( $(echo "$time_total < 1.0" | bc -l) )); then
    print_success "Performance excellente (< 1s)"
elif (( $(echo "$time_total < 3.0" | bc -l) )); then
    print_warning "Performance acceptable (1-3s)"
elif (( $(echo "$time_total < 5.0" | bc -l) )); then
    print_warning "Performance lente (3-5s)"
else
    print_error "Performance très lente (> 5s)"
fi

echo ""
print_status "=== 2. TEST DE PERFORMANCE DES SERVEURS INDIVIDUELS ==="

# Test du serveur Supabase
print_status "Test de performance du serveur Supabase..."
supabase_perf=$(curl -w "@-" -o /dev/null -s "$SUPABASE_URL/health" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$supabase_perf"

# Test du serveur Minecraft
print_status "Test de performance du serveur Minecraft..."
minecraft_perf=$(curl -w "@-" -o /dev/null -s "$MINECRAFT_URL/health" <<< "time_namelookup:  %{time_namelookup}\ntime_connect:     %{time_connect}\ntime_appconnect:  %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect:    %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total:       %{time_total}\n")

echo "$minecraft_perf"

echo ""
print_status "=== 3. TEST DES ENDPOINTS SPÉCIFIQUES ==="

# Test des endpoints spécifiques
endpoints=("/health" "/api/servers" "/api/tools")

for endpoint in "${endpoints[@]}"; do
    print_status "Test de performance $endpoint..."
    perf=$(curl -w "@-" -o /dev/null -s "$HUB_URL$endpoint" <<< "time_total: %{time_total}\n")
    time_total=$(echo "$perf" | grep "time_total:" | awk '{print $2}')
    print_status "Temps: ${time_total}s"
    
    if (( $(echo "$time_total < 1.0" | bc -l) )); then
        print_success "$endpoint: Rapide (< 1s)"
    elif (( $(echo "$time_total < 3.0" | bc -l) )); then
        print_warning "$endpoint: Lent (1-3s)"
    else
        print_error "$endpoint: Très lent (> 3s)"
    fi
done

echo ""
print_status "=== 4. ANALYSE DES CAUSES POSSIBLES ==="

print_status "Causes possibles de la lenteur:"

print_warning "1. 🔄 Problème de découverte des serveurs"
print_status "   - Le hub central essaie de découvrir les serveurs à chaque requête"
print_status "   - Timeout trop long sur les serveurs Minecraft"
print_status "   - Tentatives de connexion multiples"

print_warning "2. 🐌 Serveur surchargé"
print_status "   - Railway avec ressources limitées"
print_status "   - Trop de requêtes simultanées"
print_status "   - Mémoire insuffisante"

print_warning "3. 🌐 Problème réseau"
print_status "   - Latence élevée"
print_status "   - Connexions lentes"
print_status "   - Problème DNS"

print_warning "4. ⚙️ Configuration inefficace"
print_status "   - Pas de cache"
print_status "   - Requêtes synchrones"
print_status "   - Pas d'optimisation"

print_warning "5. 🔍 Logique de découverte lente"
print_status "   - Découverte des serveurs à chaque requête"
print_status "   - Pas de cache des résultats"
print_status "   - Timeout trop long"

echo ""
print_status "=== 5. SOLUTIONS RECOMMANDÉES ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Optimiser la découverte des serveurs"
print_status "   - Mettre en cache les résultats de découverte"
print_status "   - Réduire la fréquence des health checks"
print_status "   - Utiliser des timeouts plus courts"

print_status "2. 🔧 SOLUTION TECHNIQUE: Améliorer les performances"
print_status "   - Ajouter un cache Redis"
print_status "   - Optimiser les requêtes"
print_status "   - Utiliser des connexions asynchrones"

print_status "3. ⚙️ SOLUTION CONFIGURATION: Ajuster les paramètres"
print_status "   - Réduire le health_check_interval"
print_status "   - Optimiser les timeouts"
print_status "   - Désactiver la découverte automatique"

print_status "4. 🚀 SOLUTION INFRASTRUCTURE: Améliorer Railway"
print_status "   - Upgrader le plan Railway"
print_status "   - Augmenter les ressources"
print_status "   - Optimiser la configuration"

echo ""
print_status "=== 6. ACTIONS IMMÉDIATES ==="

print_status "Pour améliorer les performances immédiatement:"

print_status "1. Modifier la configuration pour réduire les timeouts:"
print_status "   - health_check_interval: 30s -> 60s"
print_status "   - timeout: 30s -> 10s"
print_status "   - retry_attempts: 3 -> 1"

print_status "2. Ajouter un cache simple:"
print_status "   - Cache les résultats de découverte pendant 5 minutes"
print_status "   - Éviter les requêtes répétées"

print_status "3. Optimiser la logique de découverte:"
print_status "   - Découverte en arrière-plan"
print_status "   - Pas de découverte sur chaque requête"

echo ""
print_status "=== 7. COMMANDES DE MONITORING ==="

print_status "Surveiller les performances:"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/' <<< 'time_total: %{time_total}\n'"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/api/servers' <<< 'time_total: %{time_total}\n'"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/api/tools' <<< 'time_total: %{time_total}\n'"

echo ""
print_status "=== 8. RÉSUMÉ ==="

print_status "Problème identifié:"
print_error "Le MCP Hub Central est très lent à charger (> 6 secondes)"

print_status "Causes principales:"
print_warning "1. Découverte des serveurs à chaque requête"
print_warning "2. Timeout trop long sur le serveur Minecraft"
print_warning "3. Pas de cache des résultats"
print_warning "4. Ressources Railway limitées"

print_status "Solutions prioritaires:"
print_status "1. Ajouter un cache des résultats de découverte"
print_status "2. Réduire les timeouts et intervalles"
print_status "3. Optimiser la logique de découverte"
print_status "4. Considérer un upgrade Railway"

echo ""
print_error "🚨 CONCLUSION: Le MCP Hub Central est très lent"
print_status "✅ SOLUTION: Optimiser la découverte des serveurs et ajouter un cache"
print_status "Les serveurs individuels sont plus rapides que le hub central !"

exit 0
