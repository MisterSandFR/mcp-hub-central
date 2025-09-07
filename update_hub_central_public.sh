#!/bin/bash

# Script de mise à jour du hub central public pour inclure le serveur Minecraft
# Usage: ./update_hub_central_public.sh

echo "🔧 Mise à jour du hub central public pour inclure le serveur Minecraft"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[UPDATE]${NC} $1"
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
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
SUPABASE_URL="https://supabase.mcp.coupaul.fr"

print_status "=== MISE À JOUR DU HUB CENTRAL PUBLIC ==="
print_status "Hub Central: $HUB_URL"
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Serveur Supabase: $SUPABASE_URL"

echo ""
print_status "=== 1. ANALYSE DE LA CONFIGURATION ACTUELLE ==="

# Analyser la configuration actuelle
print_status "Configuration actuelle du hub central..."
current_config=$(curl -s --connect-timeout 15 "$HUB_URL/.well-known/mcp-config" 2>/dev/null)

if [ -n "$current_config" ]; then
    print_success "Configuration actuelle récupérée"
    echo "Configuration actuelle:"
    echo "$current_config" | jq . 2>/dev/null || echo "$current_config"
    
    # Vérifier si Minecraft est déjà configuré
    if echo "$current_config" | grep -q "minecraft\|Minecraft\|MCPC"; then
        print_warning "Serveur Minecraft déjà configuré"
    else
        print_error "Serveur Minecraft NON configuré"
    fi
else
    print_error "Impossible de récupérer la configuration actuelle"
fi

echo ""
print_status "=== 2. VÉRIFICATION DES SERVEURS ==="

# Vérifier le serveur Minecraft
print_status "Vérification du serveur Minecraft..."
if curl -s --connect-timeout 15 "$MINECRAFT_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Minecraft opérationnel"
    minecraft_response=$(curl -s --connect-timeout 15 "$MINECRAFT_URL/health" 2>/dev/null)
    minecraft_name=$(echo "$minecraft_response" | grep -o '"service":"[^"]*"' | cut -d'"' -f4)
    minecraft_version=$(echo "$minecraft_response" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
    print_status "Nom: $minecraft_name"
    print_status "Version: $minecraft_version"
else
    print_error "Serveur Minecraft non opérationnel"
    exit 1
fi

# Vérifier le serveur Supabase
print_status "Vérification du serveur Supabase..."
if curl -s --connect-timeout 15 "$SUPABASE_URL/health" >/dev/null 2>&1; then
    print_success "Serveur Supabase opérationnel"
else
    print_error "Serveur Supabase non opérationnel"
fi

echo ""
print_status "=== 3. CRÉATION DE LA NOUVELLE CONFIGURATION ==="

# Créer la nouvelle configuration MCP
print_status "Création de la nouvelle configuration MCP..."

# Récupérer la configuration Minecraft
minecraft_config=$(curl -s --connect-timeout 15 "$MINECRAFT_URL/.well-known/mcp-config" 2>/dev/null)

if [ -n "$minecraft_config" ]; then
    print_success "Configuration Minecraft récupérée"
    
    # Créer la nouvelle configuration combinée
    new_config='{
  "mcpServers": {
    "supabase-mcp": {
      "command": "python",
      "args": [
        "mcp_hub.py"
      ],
      "env": {
        "MCP_SERVER_NAME": "Supabase MCP Server",
        "MCP_SERVER_VERSION": "3.1.0"
      }
    },
    "minecraft-mcpc-1.6.4": {
      "command": "python",
      "args": [
        "minecraft_mcp_server.py"
      ],
      "env": {
        "MCP_SERVER_NAME": "Minecraft MCPC+ 1.6.4 Server",
        "MCP_SERVER_VERSION": "1.0.0",
        "MINECRAFT_MCP_URL": "'$MINECRAFT_URL'"
      }
    }
  },
  "capabilities": {
    "tools": true,
    "resources": false,
    "prompts": false
  },
  "server": {
    "name": "MCP Hub Central",
    "version": "3.1.0",
    "description": "Multi-server MCP hub with Supabase and Minecraft MCPC+ 1.6.4 support",
    "url": "'$HUB_URL'/mcp",
    "endpoints": {
      "mcp": "/mcp",
      "health": "/health",
      "config": "/.well-known/mcp-config",
      "servers": "/api/servers",
      "tools": "/api/tools"
    },
    "servers": [
      {
        "id": "supabase-mcp",
        "name": "Supabase MCP Server v3.1.0",
        "url": "'$SUPABASE_URL'",
        "status": "online"
      },
      {
        "id": "minecraft-mcpc-1.6.4",
        "name": "Minecraft MCPC+ 1.6.4 Server",
        "url": "'$MINECRAFT_URL'",
        "status": "online"
      }
    ]
  }
}'
    
    print_success "Nouvelle configuration créée"
    echo "Nouvelle configuration:"
    echo "$new_config" | jq . 2>/dev/null || echo "$new_config"
    
else
    print_error "Impossible de récupérer la configuration Minecraft"
    exit 1
fi

echo ""
print_status "=== 4. MÉTHODES DE MISE À JOUR ==="

print_status "Pour mettre à jour le hub central public, plusieurs méthodes sont possibles:"

print_status "1. 🎯 MÉTHODE RECOMMANDÉE: Contact avec l'administrateur"
print_status "   - Contacter l'administrateur du hub central public"
print_status "   - Fournir la nouvelle configuration"
print_status "   - Demander la mise à jour"

print_status "2. 🔧 MÉTHODE TECHNIQUE: Accès direct (si possible)"
print_status "   - Accéder au serveur du hub central public"
print_status "   - Modifier le fichier de configuration"
print_status "   - Redémarrer le service"

print_status "3. 📝 MÉTHODE DOCUMENTATION: Créer un guide"
print_status "   - Documenter la configuration requise"
print_status "   - Créer un guide de mise à jour"
print_status "   - Fournir les fichiers de configuration"

echo ""
print_status "=== 5. CONFIGURATION REQUISE ==="

print_status "Configuration à ajouter au hub central public:"

# Créer un fichier de configuration
cat > hub_central_update_config.json << EOF
$new_config
EOF

print_success "Fichier de configuration créé: hub_central_update_config.json"

echo ""
print_status "=== 6. ACTIONS RECOMMANDÉES ==="

print_status "1. 📧 Contacter l'administrateur du hub central public"
print_status "   - Email: admin@coupaul.fr (exemple)"
print_status "   - Sujet: Mise à jour configuration MCP Hub Central"
print_status "   - Joindre: hub_central_update_config.json"

print_status "2. 📋 Message à envoyer:"
echo ""
print_status "Objet: Mise à jour configuration MCP Hub Central"
echo ""
print_status "Bonjour,"
print_status ""
print_status "Le hub central public https://mcp.coupaul.fr ne détecte pas le serveur"
print_status "Minecraft MCPC+ 1.6.4 qui est pourtant opérationnel sur:"
print_status "https://minecraft.mcp.coupaul.fr"
print_status ""
print_status "Pouvez-vous mettre à jour la configuration du hub central pour inclure"
print_status "le serveur Minecraft ?"
print_status ""
print_status "Configuration requise jointe: hub_central_update_config.json"
print_status ""
print_status "Cordialement"

echo ""
print_status "=== 7. VÉRIFICATION POST-MISE À JOUR ==="

print_status "Après la mise à jour, vérifier:"
print_status "curl -s $HUB_URL/api/servers"
print_status "curl -s $HUB_URL/api/tools"
print_status "curl -s $HUB_URL/.well-known/mcp-config"

echo ""
print_status "=== 8. SOLUTION TEMPORAIRE ==="

print_status "En attendant la mise à jour du hub central public:"
print_success "✅ Utilisez les serveurs individuels directement"
print_status "Serveur Minecraft: $MINECRAFT_URL"
print_status "Serveur Supabase: $SUPABASE_URL"

echo ""
print_success "🎉 Script de mise à jour créé !"
print_status "Fichier de configuration: hub_central_update_config.json"
print_status "Contactez l'administrateur du hub central public pour la mise à jour."

exit 0
