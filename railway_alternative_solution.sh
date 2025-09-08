#!/bin/bash

# Script de solution alternative Railway
# Usage: ./railway_alternative_solution.sh

echo "🚀 Solution alternative Railway"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[SOLUTION]${NC} $1"
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

print_status "=== SOLUTION ALTERNATIVE RAILWAY ==="

echo ""
print_status "=== 1. PROBLÈME IDENTIFIÉ ==="

print_error "Railway ne déploie pas nos changements automatiquement"
print_status "Causes possibles:"
print_warning "- Webhook GitHub cassé"
print_warning "- Cache Railway persistant"
print_warning "- Configuration Railway incorrecte"
print_warning "- Problème de build Railway"

echo ""
print_status "=== 2. SOLUTIONS IMMÉDIATES ==="

print_status "1. 🎯 SOLUTION IMMÉDIATE: Redéploiement manuel"
print_status "   - Aller sur Railway Dashboard"
print_status "   - Sélectionner le projet mcp-hub-central"
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

echo ""
print_status "=== 3. SOLUTION ALTERNATIVE: Configuration hybride ==="

print_status "En attendant que Railway fonctionne, utilisons une configuration hybride:"

print_status "Configuration hybride recommandée:"
print_status "- Supabase: Domaine public (fonctionne)"
print_status "- Minecraft: Domaine interne Railway (fonctionne)"
print_status "- Hub Central: Configuration mixte"

print_status "Avantages:"
print_success "- Supabase fonctionne immédiatement"
print_success "- Minecraft fonctionne avec Railway interne"
print_success "- Pas d'attente du déploiement Railway"

echo ""
print_status "=== 4. CONFIGURATION HYBRIDE ==="

print_status "Configuration hybride à appliquer:"

print_status "Serveur Supabase:"
print_status "  - Host: supabase.mcp.coupaul.fr (public)"
print_status "  - Port: 443"
print_status "  - Protocol: https"

print_status "Serveur Minecraft:"
print_status "  - Host: minecraft-mcp-forge-164.railway.internal (interne)"
print_status "  - Port: 3000"
print_status "  - Protocol: http"

echo ""
print_status "=== 5. IMPLÉMENTATION DE LA SOLUTION HYBRIDE ==="

print_status "Voulez-vous appliquer la configuration hybride ?"
print_status "Cette solution permettra de faire fonctionner les deux serveurs immédiatement"

read -p "Appliquer la configuration hybride ? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Application de la configuration hybride..."
    
    # Créer une configuration hybride
    cat > mcp_servers_config_hybrid.json << 'EOF'
{
  "servers": {
    "supabase": {
      "name": "Supabase MCP Server",
      "version": "3.1.0",
      "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
      "host": "supabase.mcp.coupaul.fr",
      "port": 443,
      "path": "/supabase",
      "protocol": "https",
      "status": "active",
      "tools_count": 54,
      "categories": ["database", "auth", "storage", "realtime", "security", "migration", "monitoring", "performance"],
      "github_url": "https://github.com/MisterSandFR/Supabase-MCP-SelfHosted",
      "always_works": true,
      "domain": "supabase.mcp.coupaul.fr",
      "mcp_endpoint": "/mcp",
      "health_endpoint": "/health",
      "supabase_url": "https://api.recube.gg/",
      "anon_key": "eyJhbGciOiJIUzI1NiIs...",
      "production_mode": true,
      "discovery_path": "/health",
      "discovery_timeout": 5
    },
    "minecraft": {
      "name": "Minecraft MCPC+ 1.6.4 Server",
      "version": "1.6.4",
      "description": "MCPC+ 1.6.4 server management and automation with MCP tools - Compatible with MCP Hub Central",
      "host": "minecraft-mcp-forge-164.railway.internal",
      "port": 3000,
      "path": "/minecraft",
      "protocol": "http",
      "status": "active",
      "tools_count": 4,
      "categories": ["gaming", "server_management", "automation", "world_management", "mcpc"],
      "github_url": "https://github.com/[USERNAME]/minecraft-mcpc-mcp-server",
      "always_works": false,
      "domain": "minecraft.mcp.coupaul.fr",
      "deployment": "railway",
      "mcpc_version": "1.6.4",
      "docker_enabled": true,
      "discovery_path": "/health",
      "discovery_timeout": 5,
      "timeout": 10,
      "retry_attempts": 1,
      "health_check_timeout": 10
    }
  },
  "hub": {
    "name": "MCP Hub Central",
    "version": "3.6.0",
    "description": "Multi-server MCP hub for centralized management - Hybrid configuration (Supabase public + Minecraft Railway internal)",
    "total_servers": 2,
    "total_tools": 58,
    "domain": "mcp.coupaul.fr",
    "features": [
      "automatic_discovery",
      "intelligent_routing",
      "load_balancing",
      "centralized_monitoring",
      "unified_interface",
      "advanced_security",
      "real_time_metrics",
      "hybrid_configuration"
    ]
  },
  "routing": {
    "strategy": "capability_based",
    "fallback_server": "supabase",
    "load_balancing": {
      "enabled": true,
      "algorithm": "round_robin",
      "health_check_interval": 120
    }
  },
  "security": {
    "jwt_auth": true,
    "rate_limiting": {
      "enabled": true,
      "requests_per_minute": 100,
      "burst_limit": 20
    },
    "cors": {
      "enabled": true,
      "allowed_origins": ["*"],
      "allowed_methods": ["GET", "POST", "OPTIONS"],
      "allowed_headers": ["Content-Type", "Authorization"]
    }
  },
  "monitoring": {
    "enabled": true,
    "metrics_endpoint": "/api/metrics",
    "health_check_interval": 120,
    "cache_duration": 300,
    "discovery_timeout": 10,
    "alerting": {
      "enabled": true,
      "email": "alerts@mcp.coupaul.fr",
      "webhook": "https://hooks.slack.com/services/..."
    }
  }
}
EOF
    
    print_success "Configuration hybride créée: mcp_servers_config_hybrid.json"
    print_status "Cette configuration utilise:"
    print_status "- Supabase: Domaine public (fonctionne)"
    print_status "- Minecraft: Domaine interne Railway (fonctionne)"
    
else
    print_status "Configuration hybride non appliquée"
fi

echo ""
print_status "=== 6. COMMANDES DE VÉRIFICATION ==="

print_status "Après le redéploiement Railway, vérifier:"
print_status "curl -s 'https://mcp.coupaul.fr/api/servers' | jq '.hub.version'"
print_status "curl -w '@-' -o /dev/null -s 'https://mcp.coupaul.fr/' <<< 'time_total: %{time_total}\n'"

echo ""
print_status "=== 7. RÉSUMÉ ==="

print_status "Solutions disponibles:"
print_status "1. 🎯 Redéploiement manuel Railway (recommandé)"
print_status "2. 🔧 Configuration hybride (solution immédiate)"
print_status "3. ⚙️ Vérification des webhooks GitHub"
print_status "4. 🚀 Nouveau projet Railway (si nécessaire)"

print_status "Recommandation:"
print_warning "Commencer par le redéploiement manuel Railway"
print_status "Si cela ne fonctionne pas, utiliser la configuration hybride"

echo ""
print_error "🚨 CONCLUSION: Railway ne déploie pas automatiquement"
print_status "✅ SOLUTION: Redéploiement manuel ou configuration hybride"

exit 0
