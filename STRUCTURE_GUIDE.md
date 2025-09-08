# 📁 Structure des Projets MCP - Guide de Clarification

## 🎯 Vue d'ensemble de la Structure

Votre workspace contient **3 projets GitHub séparés** dans des répertoires distincts :

```
C:\Users\coupaul\Documents\GitHub\
├── mcp-hub-central\                    ← Hub Central (Gestionnaire)
├── ng-supabase-mcp\                    ← Serveur Supabase MCP
└── Minecraft-MCP-Forge-1.6.4\          ← Serveur Minecraft MCP
```

## 📂 Détail de Chaque Projet

### 1. **mcp-hub-central** (Répertoire actuel)
- **Rôle**: Hub de gestion central
- **Type**: Gestionnaire de serveurs MCP
- **Smithery**: ❌ Non nécessaire (hub interne)
- **Fichiers principaux**:
  - `mcp_hub_central.py` - Serveur principal
  - `mcp-projects-shared-config.yaml` - Configuration partagée
  - `sync_mcp_projects_smithery.sh` - Script de synchronisation
  - `validate_mcp_projects.sh` - Script de validation

### 2. **ng-supabase-mcp** (Répertoire frère)
- **Rôle**: Serveur MCP pour Supabase
- **Type**: Serveur MCP autonome
- **Smithery**: ✅ Configuré (`smithery.yaml`)
- **Chemin relatif**: `../ng-supabase-mcp/`
- **Fichiers principaux**:
  - `smithery.yaml` - Configuration Smithery.ai
  - `package.json` - Configuration Node.js
  - `requirements.txt` - Dépendances Python
  - `src/supabase_server.py` - Serveur principal

### 3. **Minecraft-MCP-Forge-1.6.4** (Répertoire frère)
- **Rôle**: Serveur MCP pour Minecraft
- **Type**: Serveur MCP spécialisé
- **Smithery**: ✅ Configuré (`smithery-metadata.json`)
- **Chemin relatif**: `../Minecraft-MCP-Forge-1.6.4/`
- **Fichiers principaux**:
  - `smithery-metadata.json` - Configuration Smithery.ai
  - `package.json` - Configuration Node.js
  - `requirements.txt` - Dépendances Python
  - `server/src/index.ts` - Serveur principal

## 🔧 Scripts de Gestion

### Script de Validation Simple
```bash
# Depuis mcp-hub-central/
./validate_mcp_projects.sh
```
**Fonction**: Valide la structure et les configurations sans modification

### Script de Synchronisation Complet
```bash
# Depuis mcp-hub-central/
./sync_mcp_projects_smithery.sh
```
**Fonction**: Synchronise les versions et configurations entre tous les projets

## 📊 Configuration Partagée

### Fichier Central
- **Nom**: `mcp-projects-shared-config.yaml`
- **Localisation**: `mcp-hub-central/`
- **Rôle**: Configuration commune pour tous les projets

### Variables d'Environnement
```yaml
# Chemins relatifs depuis mcp-hub-central/
SUPABASE_PROJECT: "../ng-supabase-mcp"
MINECRAFT_PROJECT: "../Minecraft-MCP-Forge-1.6.4"
```

## 🚀 Déploiement

### Ordre de Déploiement Recommandé
1. **Hub Central** (depuis `mcp-hub-central/`)
   ```bash
   ./deploy_to_public_server.sh
   ```

2. **Supabase MCP** (depuis `ng-supabase-mcp/`)
   ```bash
   ./scripts/deploy-selfhosted.sh
   ```

3. **Minecraft MCP** (depuis `Minecraft-MCP-Forge-1.6.4/`)
   ```bash
   ./deploy-railway.sh
   ```

## 🔍 Vérifications Rapides

### Vérifier la Structure
```bash
# Depuis mcp-hub-central/
ls -la ../ng-supabase-mcp/
ls -la ../Minecraft-MCP-Forge-1.6.4/
```

### Vérifier les Configurations Smithery
```bash
# Depuis mcp-hub-central/
cat ../ng-supabase-mcp/smithery.yaml
cat ../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json
```

### Vérifier les Versions
```bash
# Depuis mcp-hub-central/
grep "version:" ../ng-supabase-mcp/smithery.yaml
grep '"version"' ../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json
```

## ⚠️ Points d'Attention

### Chemins Relatifs
- Tous les scripts utilisent des chemins relatifs (`../`)
- Exécuter depuis le bon répertoire est crucial
- Les chemins sont définis dans les variables `SUPABASE_PROJECT` et `MINECRAFT_PROJECT`

### Permissions
```bash
# Rendre les scripts exécutables
chmod +x validate_mcp_projects.sh
chmod +x sync_mcp_projects_smithery.sh
```

### Validation Manuelle
En cas de problème avec les scripts, vérifier manuellement :
1. Existence des répertoires
2. Présence des fichiers de configuration
3. Cohérence des versions
4. Validité des formats (YAML/JSON)

## 📋 Checklist de Validation

- [ ] Répertoire `../ng-supabase-mcp/` existe
- [ ] Répertoire `../Minecraft-MCP-Forge-1.6.4/` existe
- [ ] Fichier `../ng-supabase-mcp/smithery.yaml` existe
- [ ] Fichier `../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json` existe
- [ ] Toutes les versions sont à `3.7.0`
- [ ] Les scripts sont exécutables
- [ ] Les configurations Smithery sont valides

---

*Ce guide clarifie la structure pour éviter les blocages de terminal et les erreurs de chemins.*

