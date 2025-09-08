#!/bin/bash

# Guide de configuration Smithery pour le MCP Hub Central
# Usage: ./setup_smithery.sh

echo "🔧 Configuration Smithery pour le MCP Hub Central"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[SMITHERY]${NC} $1"
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

print_status "=== CONFIGURATION SMITHERY POUR MCP HUB CENTRAL ==="

echo ""
print_status "=== 1. QU'EST-CE QUE SMITHERY ? ==="

print_status "Smithery est un outil de gestion des serveurs MCP qui permet:"
print_success "✅ Gérer plusieurs serveurs MCP depuis une interface unique"
print_success "✅ Configurer et déployer des serveurs MCP facilement"
print_success "✅ Monitorer l'état des serveurs MCP"
print_success "✅ Créer des configurations MCP complexes"
print_success "✅ Intégrer avec des services cloud (Railway, Vercel, etc.)"

echo ""
print_status "=== 2. INSTALLATION DE SMITHERY ==="

print_status "Méthodes d'installation:"

print_status "1. 🐍 Installation via pip:"
print_status "   pip install smithery"

print_status "2. 📦 Installation via npm:"
print_status "   npm install -g smithery"

print_status "3. 🐳 Installation via Docker:"
print_status "   docker pull smithery/smithery"

print_status "4. 🚀 Installation via GitHub:"
print_status "   git clone https://github.com/smithery/smithery"
print_status "   cd smithery && pip install -e ."

echo ""
print_status "=== 3. CONFIGURATION POUR VOTRE HUB CENTRAL ==="

print_status "Configuration Smithery pour votre setup:"

print_status "1. 📝 Créer un fichier de configuration smithery.yaml:"
print_status "   touch smithery.yaml"

print_status "2. ⚙️ Contenu du fichier smithery.yaml:"
cat << 'EOF'
# Configuration Smithery pour MCP Hub Central
version: "1.0"

servers:
  # Hub Central Principal
  mcp-hub-central:
    name: "MCP Hub Central"
    url: "https://mcp.coupaul.fr"
    type: "hub"
    endpoints:
      mcp: "/mcp"
      health: "/health"
      config: "/.well-known/mcp-config"
      servers: "/api/servers"
      tools: "/api/tools"
    status: "online"
    description: "Multi-server MCP hub for centralized management"

  # Serveur Supabase MCP
  supabase-mcp:
    name: "Supabase MCP Server"
    url: "https://supabase.mcp.coupaul.fr"
    type: "mcp-server"
    endpoints:
      mcp: "/mcp"
      health: "/health"
      tools: "/api/tools"
    status: "online"
    tools_count: 54
    description: "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management"
    capabilities:
      - "database"
      - "auth"
      - "storage"
      - "realtime"
      - "security"
      - "migration"
      - "monitoring"
      - "performance"

  # Serveur Minecraft MCP
  minecraft-mcp:
    name: "Minecraft MCPC+ 1.6.4 Server"
    url: "https://minecraft.mcp.coupaul.fr"
    type: "mcp-server"
    endpoints:
      mcp: "/mcp"
      health: "/health"
      tools: "/api/tools"
    status: "online"
    tools_count: 4
    description: "MCPC+ 1.6.4 server management and automation with MCP tools"
    capabilities:
      - "gaming"
      - "server_management"
      - "automation"
      - "world_management"
      - "mcpc"

# Configuration des environnements
environments:
  production:
    hub_url: "https://mcp.coupaul.fr"
    supabase_url: "https://supabase.mcp.coupaul.fr"
    minecraft_url: "https://minecraft.mcp.coupaul.fr"
    
  development:
    hub_url: "http://localhost:8080"
    supabase_url: "http://localhost:8001"
    minecraft_url: "http://localhost:8002"

# Configuration des outils
tools:
  auto_discovery: false
  health_check_interval: 120
  cache_duration: 300
  timeout: 15

# Configuration des notifications
notifications:
  enabled: true
  webhook: "https://hooks.slack.com/services/..."
  email: "admin@mcp.coupaul.fr"
EOF

echo ""
print_status "=== 4. COMMANDES SMITHERY ESSENTIELLES ==="

print_status "Commandes de base Smithery:"

print_status "1. 🚀 Démarrer Smithery:"
print_status "   smithery start"

print_status "2. 📊 Vérifier l'état des serveurs:"
print_status "   smithery status"

print_status "3. 🔍 Lister les serveurs:"
print_status "   smithery list"

print_status "4. 🔧 Configurer un serveur:"
print_status "   smithery config <server-name>"

print_status "5. 📈 Monitorer les serveurs:"
print_status "   smithery monitor"

print_status "6. 🔄 Redémarrer un serveur:"
print_status "   smithery restart <server-name>"

print_status "7. 📝 Voir les logs:"
print_status "   smithery logs <server-name>"

print_status "8. 🧪 Tester un serveur:"
print_status "   smithery test <server-name>"

echo ""
print_status "=== 5. INTÉGRATION AVEC VOTRE HUB CENTRAL ==="

print_status "Comment intégrer Smithery avec votre hub central:"

print_status "1. 🔗 Configuration du hub central:"
print_status "   - Ajouter Smithery comme client MCP"
print_status "   - Configurer les endpoints Smithery"
print_status "   - Intégrer avec les variables d'environnement"

print_status "2. 📊 Monitoring unifié:"
print_status "   - Smithery surveille tous vos serveurs MCP"
print_status "   - Alertes automatiques en cas de problème"
print_status "   - Dashboard unifié pour tous les serveurs"

print_status "3. 🔧 Gestion centralisée:"
print_status "   - Déploiement via Smithery"
print_status "   - Configuration centralisée"
print_status "   - Mise à jour des serveurs"

echo ""
print_status "=== 6. VARIABLES D'ENVIRONNEMENT SMITHERY ==="

print_status "Variables à configurer pour Smithery:"

print_success "✅ SMITHERY_CONFIG_PATH=./smithery.yaml"
print_status "   Description: Chemin vers le fichier de configuration"

print_success "✅ SMITHERY_HUB_URL=https://mcp.coupaul.fr"
print_status "   Description: URL du hub central"

print_success "✅ SMITHERY_SUPABASE_URL=https://supabase.mcp.coupaul.fr"
print_status "   Description: URL du serveur Supabase MCP"

print_success "✅ SMITHERY_MINECRAFT_URL=https://minecraft.mcp.coupaul.fr"
print_status "   Description: URL du serveur Minecraft MCP"

print_success "✅ SMITHERY_LOG_LEVEL=INFO"
print_status "   Description: Niveau de log Smithery"

print_success "✅ SMITHERY_HEALTH_CHECK_INTERVAL=120"
print_status "   Description: Intervalle de vérification de santé (secondes)"

echo ""
print_status "=== 7. CONFIGURATION RAILWAY AVEC SMITHERY ==="

print_status "Comment configurer Smithery sur Railway:"

print_status "1. 🎯 Créer un nouveau service Railway:"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Créer un nouveau service"
print_status "   - Choisir 'Deploy from GitHub repo'"

print_status "2. ⚙️ Configurer les variables d'environnement:"
print_status "   - SMITHERY_CONFIG_PATH=./smithery.yaml"
print_status "   - SMITHERY_HUB_URL=https://mcp.coupaul.fr"
print_status "   - SMITHERY_SUPABASE_URL=https://supabase.mcp.coupaul.fr"
print_status "   - SMITHERY_MINECRAFT_URL=https://minecraft.mcp.coupaul.fr"

print_status "3. 📝 Créer un Dockerfile pour Smithery:"
cat << 'EOF'
FROM python:3.11-slim

WORKDIR /app

# Installer Smithery
RUN pip install smithery

# Copier la configuration
COPY smithery.yaml /app/

# Exposer le port
EXPOSE 8080

# Démarrer Smithery
CMD ["smithery", "start", "--port", "8080"]
EOF

echo ""
print_status "=== 8. COMMANDES DE TEST ==="

print_status "Tester Smithery après configuration:"

print_status "1. Vérifier l'état:"
print_status "   smithery status"

print_status "2. Lister les serveurs:"
print_status "   smithery list"

print_status "3. Tester la connectivité:"
print_status "   smithery test mcp-hub-central"
print_status "   smithery test supabase-mcp"
print_status "   smithery test minecraft-mcp"

print_status "4. Voir les logs:"
print_status "   smithery logs --all"

echo ""
print_status "=== 9. RÉSUMÉ ==="

print_status "Configuration Smithery pour votre hub central:"

print_success "✅ Installation: pip install smithery"
print_success "✅ Configuration: smithery.yaml"
print_success "✅ Serveurs: Hub Central + Supabase + Minecraft"
print_success "✅ Monitoring: Automatique"
print_success "✅ Gestion: Centralisée"

print_status "Actions recommandées:"
print_status "1. Installer Smithery"
print_status "2. Créer le fichier smithery.yaml"
print_status "3. Configurer les variables d'environnement"
print_status "4. Tester la connectivité avec vos serveurs"
print_status "5. Déployer sur Railway si souhaité"

echo ""
print_success "🚀 CONCLUSION: Smithery pour gérer votre MCP Hub Central"
print_status "✅ SOLUTION: Configuration centralisée et monitoring unifié"

exit 0
