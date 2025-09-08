#!/bin/bash

# Script de validation simple pour les projets MCP
# Version 3.7.0 - Janvier 2025

echo "🔍 Validation des projets MCP pour Smithery.ai"
echo "=============================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonctions de log
success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Vérifier la structure des répertoires
echo "📁 Vérification de la structure des répertoires..."

if [ -d "../ng-supabase-mcp" ]; then
    success "Répertoire Supabase MCP trouvé: ../ng-supabase-mcp"
else
    error "Répertoire Supabase MCP non trouvé: ../ng-supabase-mcp"
fi

if [ -d "../Minecraft-MCP-Forge-1.6.4" ]; then
    success "Répertoire Minecraft MCP trouvé: ../Minecraft-MCP-Forge-1.6.4"
else
    error "Répertoire Minecraft MCP non trouvé: ../Minecraft-MCP-Forge-1.6.4"
fi

echo ""

# Vérifier les fichiers de configuration Smithery
echo "🔧 Vérification des configurations Smithery..."

if [ -f "../ng-supabase-mcp/smithery.yaml" ]; then
    success "Configuration Smithery trouvée: ../ng-supabase-mcp/smithery.yaml"
else
    error "Configuration Smithery manquante: ../ng-supabase-mcp/smithery.yaml"
fi

if [ -f "../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json" ]; then
    success "Configuration Smithery trouvée: ../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json"
else
    error "Configuration Smithery manquante: ../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json"
fi

echo ""

# Vérifier les versions
echo "📊 Vérification des versions..."

# Vérifier la version dans smithery.yaml
if [ -f "../ng-supabase-mcp/smithery.yaml" ]; then
    VERSION_SUPABASE=$(grep "version:" ../ng-supabase-mcp/smithery.yaml | head -1 | cut -d'"' -f2)
    if [ "$VERSION_SUPABASE" = "3.7.0" ]; then
        success "Version Supabase MCP: $VERSION_SUPABASE"
    else
        warning "Version Supabase MCP: $VERSION_SUPABASE (attendu: 3.7.0)"
    fi
fi

# Vérifier la version dans smithery-metadata.json
if [ -f "../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json" ]; then
    VERSION_MINECRAFT=$(grep '"version"' ../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json | head -1 | cut -d'"' -f4)
    if [ "$VERSION_MINECRAFT" = "3.7.0" ]; then
        success "Version Minecraft MCP: $VERSION_MINECRAFT"
    else
        warning "Version Minecraft MCP: $VERSION_MINECRAFT (attendu: 3.7.0)"
    fi
fi

echo ""

# Vérifier les fichiers package.json
echo "📦 Vérification des fichiers package.json..."

if [ -f "../ng-supabase-mcp/package.json" ]; then
    success "package.json Supabase MCP trouvé"
    PACKAGE_VERSION_SUPABASE=$(grep '"version"' ../ng-supabase-mcp/package.json | cut -d'"' -f4)
    if [ "$PACKAGE_VERSION_SUPABASE" = "3.7.0" ]; then
        success "Version package.json Supabase: $PACKAGE_VERSION_SUPABASE"
    else
        warning "Version package.json Supabase: $PACKAGE_VERSION_SUPABASE (attendu: 3.7.0)"
    fi
else
    error "package.json Supabase MCP manquant"
fi

if [ -f "../Minecraft-MCP-Forge-1.6.4/package.json" ]; then
    success "package.json Minecraft MCP trouvé"
    PACKAGE_VERSION_MINECRAFT=$(grep '"version"' ../Minecraft-MCP-Forge-1.6.4/package.json | cut -d'"' -f4)
    if [ "$PACKAGE_VERSION_MINECRAFT" = "3.7.0" ]; then
        success "Version package.json Minecraft: $PACKAGE_VERSION_MINECRAFT"
    else
        warning "Version package.json Minecraft: $PACKAGE_VERSION_MINECRAFT (attendu: 3.7.0)"
    fi
else
    error "package.json Minecraft MCP manquant"
fi

echo ""

# Résumé
echo "📋 Résumé de la validation"
echo "=========================="
echo ""
echo "🏗️ Structure des projets:"
echo "   • Hub Central: $(pwd)"
echo "   • Supabase MCP: ../ng-supabase-mcp"
echo "   • Minecraft MCP: ../Minecraft-MCP-Forge-1.6.4"
echo ""
echo "🔧 Configurations Smithery:"
echo "   • Supabase: smithery.yaml (YAML)"
echo "   • Minecraft: smithery-metadata.json (JSON)"
echo ""
echo "📊 Versions:"
echo "   • Standard: 3.7.0"
echo "   • Date: 2025-01-08"
echo ""
echo "✅ Validation terminée!"
echo ""
echo "🚀 Prochaines étapes:"
echo "   1. Vérifier les configurations manuellement"
echo "   2. Publier sur Smithery.ai"
echo "   3. Tester les intégrations"
echo ""

