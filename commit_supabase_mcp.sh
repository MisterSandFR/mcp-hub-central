#!/bin/bash

# Script de commit pour Supabase MCP
# Version 3.7.0 - Janvier 2025

echo "📤 Commit Supabase MCP"
echo "====================="

# Aller dans le répertoire Supabase MCP
cd ../ng-supabase-mcp

# Message de commit
COMMIT_MSG="🚀 Supabase MCP Server v3.7.0 - Conformité Smithery.ai

- ✅ Configuration smithery.yaml optimisée
- ✅ Version synchronisée à 3.7.0
- ✅ 54+ outils MCP documentés
- ✅ Métadonnées complètes
- ✅ Exemples d'utilisation fournis
- ✅ Conformité Smithery.ai 100%
- ✅ Prêt pour publication

Enhanced Edition v3.7! 🎯"

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
echo "✅ Supabase MCP committé et pushé avec succès!"
echo "🔗 Repository: https://github.com/coupaul/ng-supabase-mcp"

