#!/bin/bash

# Script de monitoring du redéploiement Railway
# Usage: ./monitor_railway_redeploy.sh

echo "⏳ Monitoring du redéploiement Railway"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[MONITOR]${NC} $1"
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

print_status "=== MONITORING DU REDÉPLOIEMENT RAILWAY ==="
print_status "Hub Central: $HUB_URL"
print_status "Démarrage du monitoring..."

# Fonction pour vérifier la version
check_version() {
    local version=$(curl -s --max-time 10 "$HUB_URL/api/servers" 2>/dev/null | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "$version"
}

# Fonction pour vérifier les performances
check_performance() {
    local perf=$(curl -w "@-" -o /dev/null -s --max-time 15 "$HUB_URL/" <<< "time_total: %{time_total}\n" 2>/dev/null)
    local time_total=$(echo "$perf" | grep "time_total:" | awk '{print $2}')
    echo "$time_total"
}

# Fonction pour vérifier le serveur Minecraft
check_minecraft() {
    local response=$(curl -s --max-time 10 "$HUB_URL/api/servers" 2>/dev/null)
    if echo "$response" | grep -q "minecraft"; then
        echo "detected"
    else
        echo "not_detected"
    fi
}

echo ""
print_status "=== MONITORING EN COURS ==="
print_status "Vérification toutes les 30 secondes..."
print_status "Appuyez sur Ctrl+C pour arrêter"

# Compteur
counter=0
max_attempts=20  # 10 minutes maximum

while [ $counter -lt $max_attempts ]; do
    counter=$((counter + 1))
    
    print_status "--- Tentative $counter/$max_attempts ---"
    
    # Vérifier la version
    version=$(check_version)
    if [ -n "$version" ]; then
        print_status "Version détectée: $version"
        
        if [ "$version" = "3.3.0" ]; then
            print_success "✅ Version à jour (3.3.0) - Redéploiement réussi !"
            
            # Vérifier les performances
            performance=$(check_performance)
            if [ -n "$performance" ]; then
                print_status "Performance: ${performance}s"
                
                if (( $(echo "$performance < 3.0" | bc -l 2>/dev/null || echo "0") )); then
                    print_success "✅ Performances bonnes (< 3s)"
                else
                    print_warning "⚠️ Performances encore lentes (> 3s)"
                fi
            fi
            
            # Vérifier le serveur Minecraft
            minecraft_status=$(check_minecraft)
            if [ "$minecraft_status" = "detected" ]; then
                print_success "✅ Serveur Minecraft détecté"
            else
                print_warning "⚠️ Serveur Minecraft non détecté"
            fi
            
            echo ""
            print_success "🎉 REDÉPLOIEMENT RÉUSSI !"
            print_status "Le MCP Hub Central est maintenant à jour avec la version 3.3.0"
            exit 0
        else
            print_warning "⚠️ Version obsolète ($version) - Redéploiement en cours..."
        fi
    else
        print_error "❌ Impossible de vérifier la version"
    fi
    
    # Attendre 30 secondes
    if [ $counter -lt $max_attempts ]; then
        print_status "Attente de 30 secondes..."
        sleep 30
    fi
done

echo ""
print_error "🚨 TIMEOUT: Redéploiement Railway non détecté après 10 minutes"
print_warning "Actions recommandées:"
print_status "1. Aller sur Railway Dashboard manuellement"
print_status "2. Vérifier les logs Railway"
print_status "3. Forcer un redéploiement manuel"
print_status "4. Vérifier les variables d'environnement"

echo ""
print_status "=== COMMANDES DE VÉRIFICATION MANUELLE ==="
print_status "curl -s '$HUB_URL/api/servers' | jq '.hub.version'"
print_status "curl -w '@-' -o /dev/null -s '$HUB_URL/' <<< 'time_total: %{time_total}\n'"

exit 1
