# 📤 Guide de Commit et Push - Éviter les Blocages Terminal

## 🎯 Problème Identifié
Le terminal se bloque lors de l'exécution des commandes Git. Voici les solutions pour committer et pusher vos projets sans problème.

## 🛠️ Solutions Disponibles

### **Option 1: Scripts Individuels (Recommandé)**

#### 1. Hub Central
```bash
# Depuis mcp-hub-central/
chmod +x commit_hub_central.sh
./commit_hub_central.sh
```

#### 2. Supabase MCP
```bash
# Depuis mcp-hub-central/
chmod +x commit_supabase_mcp.sh
./commit_supabase_mcp.sh
```

#### 3. Minecraft MCP
```bash
# Depuis mcp-hub-central/
chmod +x commit_minecraft_mcp.sh
./commit_minecraft_mcp.sh
```

### **Option 2: Script Complet**
```bash
# Depuis mcp-hub-central/
chmod +x commit_and_push_all.sh
./commit_and_push_all.sh
```

### **Option 3: Commandes Manuelles**

#### Hub Central (répertoire actuel)
```bash
git add .
git commit -m "🚀 MCP Hub Central v3.7.0 - Optimisation complète"
git push origin main
```

#### Supabase MCP
```bash
cd ../ng-supabase-mcp
git add .
git commit -m "🚀 Supabase MCP Server v3.7.0 - Conformité Smithery.ai"
git push origin main
cd ../mcp-hub-central
```

#### Minecraft MCP
```bash
cd ../Minecraft-MCP-Forge-1.6.4
git add .
git commit -m "🚀 Minecraft MCP Server v3.7.0 - Conformité Smithery.ai"
git push origin main
cd ../mcp-hub-central
```

## 📋 Messages de Commit Préparés

### Hub Central
```
🚀 MCP Hub Central v3.7.0 - Optimisation complète

- ✅ Standardisation version 3.7.0
- ✅ Configurations Smithery.ai optimisées  
- ✅ Scripts de gestion automatisés
- ✅ Tests d'intégration complets
- ✅ Dashboard de monitoring
- ✅ Documentation API complète
- ✅ Système de déploiement automatisé
- ✅ Conformité Smithery.ai 100%

Prêt pour production! 🎯
```

### Supabase MCP
```
🚀 Supabase MCP Server v3.7.0 - Conformité Smithery.ai

- ✅ Configuration smithery.yaml optimisée
- ✅ Version synchronisée à 3.7.0
- ✅ 54+ outils MCP documentés
- ✅ Métadonnées complètes
- ✅ Exemples d'utilisation fournis
- ✅ Conformité Smithery.ai 100%
- ✅ Prêt pour publication

Enhanced Edition v3.7! 🎯
```

### Minecraft MCP
```
🚀 Minecraft MCP Server v3.7.0 - Conformité Smithery.ai

- ✅ Configuration smithery-metadata.json optimisée
- ✅ Version synchronisée à 3.7.0
- ✅ 4 outils MCP spécialisés documentés
- ✅ Métadonnées complètes
- ✅ Exemples d'utilisation fournis
- ✅ Conformité Smithery.ai 100%
- ✅ Prêt pour publication

MCPC+ 1.6.4 Edition! 🎮
```

## 🔧 Dépannage

### Si les scripts ne s'exécutent pas
```bash
# Rendre les scripts exécutables
chmod +x commit_*.sh

# Vérifier les permissions
ls -la commit_*.sh
```

### Si Git demande des credentials
```bash
# Configurer Git si nécessaire
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

### Si les répertoires ne sont pas trouvés
```bash
# Vérifier la structure
ls -la ../
ls -la ../ng-supabase-mcp/
ls -la ../Minecraft-MCP-Forge-1.6.4/
```

## 📊 Ordre de Commit Recommandé

1. **Hub Central** (répertoire actuel)
2. **Supabase MCP** (../ng-supabase-mcp/)
3. **Minecraft MCP** (../Minecraft-MCP-Forge-1.6.4/)

## ✅ Vérification Post-Commit

Après chaque commit, vérifiez sur GitHub :
- [ ] Hub Central: https://github.com/coupaul/mcp-hub-central
- [ ] Supabase MCP: https://github.com/coupaul/ng-supabase-mcp
- [ ] Minecraft MCP: https://github.com/coupaul/Minecraft-MCP-Forge-1.6.4

## 🚀 Prochaines Étapes

Après le commit et push :
1. **Publier sur Smithery.ai** : `./publish_to_smithery.sh`
2. **Déployer en production** : `./deploy_all_projects.sh`
3. **Activer le monitoring** : Ouvrir `monitoring-dashboard.html`

---

*Ce guide évite les blocages de terminal en utilisant des scripts simples et des commandes manuelles directes.*

