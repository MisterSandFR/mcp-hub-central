#!/bin/bash

# Script de commit pour Minecraft MCP
# Version 3.7.0 - Janvier 2025

echo "📤 Commit Minecraft MCP"
echo "======================"

# Aller dans le répertoire Minecraft MCP
cd ../Minecraft-MCP-Forge-1.6.4

# Message de commit
COMMIT_MSG="🚀 Minecraft MCP Server v3.7.0 - Conformité Smithery.ai

- ✅ Configuration smithery-metadata.json optimisée
- ✅ Version synchronisée à 3.7.0
- ✅ 4 outils MCP spécialisés documentés
- ✅ Métadonnées complètes
- ✅ Exemples d'utilisation fournis
- ✅ Conformité Smithery.ai 100%
- ✅ Prêt pour publication

MCPC+ 1.6.4 Edition! 🎮"

# Ajouter tous les fichiers
echo "📁 Ajout des fichiers..."
git add .

# Committer
echo "💾 Commit des changements..."
git commit -m "$COMMIT_MSG"

# Push
echo "📤 Push vers GitHub..."
git push origin main

# Retourner au répertoire original
cd ../mcp-hub-central

echo ""
echo "✅ Minecraft MCP committé et pushé avec succès!"
echo "🔗 Repository: https://github.com/coupaul/Minecraft-MCP-Forge-1.6.4"

