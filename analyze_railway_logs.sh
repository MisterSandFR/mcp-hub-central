#!/bin/bash

# Script d'analyse des logs Railway pour le serveur Minecraft MCPC+ 1.6.4
# Usage: ./analyze_railway_logs.sh

echo "📊 Analyse des logs Railway - Serveur Minecraft MCPC+ 1.6.4"

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

print_status "=== ANALYSE DES LOGS RAILWAY ==="
print_status "Date: Sep 7, 2025, 10:37 PM"
print_status "Problème: Erreurs 502 systématiques sur tous les endpoints"

echo ""
print_status "=== PATTERN DÉTECTÉ ==="
print_error "Tous les endpoints retournent 502:"
print_error "  - GET / → 502"
print_error "  - GET /health → 502"
print_error "  - GET /api/tools → 502"
print_error "  - GET /mcp → 502"
print_error "  - GET /.well-known/mcp-config → 502"
print_error "  - GET /mcp/info → 502"
print_error "  - GET /mcp/tools → 502"

echo ""
print_status "=== DIAGNOSTIC ==="
print_warning "Problème identifié: Application non démarrée"
print_warning "Cause probable: Erreur de configuration ou de démarrage"
print_warning "Temps de réponse: 1-277ms (très rapide = erreur immédiate)"

echo ""
print_status "=== CAUSES POSSIBLES ==="
print_warning "1. Port non exposé correctement dans Railway"
print_warning "2. Application ne démarre pas sur le port 3000"
print_warning "3. Erreur dans le code de l'application"
print_warning "4. Variables d'environnement manquantes"
print_warning "5. Dockerfile incorrect"
print_warning "6. Dépendances manquantes"

echo ""
print_status "=== SOLUTIONS RECOMMANDÉES ==="

print_status "1. Vérifier la configuration Railway:"
print_status "   - Port 3000 exposé dans railway.json"
print_status "   - Variables d'environnement configurées"
print_status "   - Buildpack ou Dockerfile correct"

print_status "2. Vérifier le code de l'application:"
print_status "   - Serveur HTTP démarre sur le port 3000"
print_status "   - Gestion des erreurs correcte"
print_status "   - Dépendances installées"

print_status "3. Tester localement:"
print_status "   - docker build -t minecraft-mcp ."
print_status "   - docker run -p 3000:3000 minecraft-mcp"
print_status "   - Vérifier que l'application démarre"

print_status "4. Redéployer avec logs:"
print_status "   - railway up --detach"
print_status "   - railway logs --follow"
print_status "   - Vérifier les erreurs de démarrage"

echo ""
print_status "=== COMMANDES DE DEBUG ==="
print_status "Logs en temps réel: railway logs --follow"
print_status "Statut du service: railway status"
print_status "Redéployer: railway up"
print_status "Test local: docker run -p 3000:3000 [image]"

echo ""
print_status "=== MESSAGE POUR LE DÉVELOPPEUR ==="
echo ""
print_warning "🚨 PROBLÈME CRITIQUE DÉTECTÉ"
print_warning "Le serveur Minecraft MCPC+ 1.6.4 retourne des erreurs 502 sur tous les endpoints."
print_warning "L'application ne démarre pas correctement sur Railway."
echo ""
print_status "Actions immédiates requises:"
print_status "1. Vérifier les logs Railway: railway logs --follow"
print_status "2. Vérifier la configuration du port 3000"
print_status "3. Tester localement avec Docker"
print_status "4. Redéployer après correction"
echo ""
print_status "Le problème n'est pas lié au hub central mais au démarrage de l'application elle-même."

exit 1
