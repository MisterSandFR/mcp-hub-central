# 🚀 MCP Hub Central - Écosystème de Serveurs MCP

[![Version](https://img.shields.io/badge/version-3.7.0-blue.svg)](https://github.com/coupaul/mcp-hub-central)
[![Smithery.ai](https://img.shields.io/badge/Smithery.ai-compliant-green.svg)](https://smithery.ai)
[![Railway](https://img.shields.io/badge/deployed%20on-Railway-0B0D0E.svg)](https://railway.app)

## 📋 Vue d'ensemble

Ce workspace contient un écosystème complet de serveurs MCP (Model Context Protocol) interconnectés, optimisés pour la conformité Smithery.ai et la maintenabilité.

### 🏗️ Architecture des Projets

```
mcp-hub-central/
├── 🎯 Hub Central (Gestionnaire principal)
├── 🗄️ Supabase MCP Server (54+ outils)
└── 🎮 Minecraft MCP Server (4 outils spécialisés)
```

## 🎯 Projets Inclus

### 1. **Hub Central** (`mcp-hub-central/`)
- **Rôle**: Gestionnaire central des serveurs MCP
- **Type**: Hub de coordination
- **Smithery**: ❌ Non nécessaire (hub interne)
- **URL**: https://mcp.coupaul.fr
- **Port**: 8080

### 2. **Supabase MCP Server** (`ng-supabase-mcp/`)
- **Rôle**: Serveur MCP pour gestion complète Supabase
- **Type**: Serveur MCP autonome
- **Smithery**: ✅ Configuré (`smithery.yaml`)
- **URL**: https://supabase.mcp.coupaul.fr
- **Port**: 8000
- **Outils**: 54 outils MCP

### 3. **Minecraft MCP Server** (`Minecraft-MCP-Forge-1.6.4/`)
- **Rôle**: Serveur MCP pour développement Minecraft MCPC+ 1.6.4
- **Type**: Serveur MCP spécialisé
- **Smithery**: ✅ Configuré (`smithery-metadata.json`)
- **URL**: https://minecraft.mcp.coupaul.fr
- **Port**: 3000
- **Outils**: 4 outils MCP

## 🔧 Configuration Standardisée

### Versions Synchronisées
- **Version commune**: `3.7.0`
- **Date de release**: `2025-01-08`
- **Standard**: `smithery-ai-compliant`

### Dépendances Unifiées
```yaml
# Python (tous projets)
python: ">=3.11"
fastapi: "0.104.1"
uvicorn: "0.24.0"
pydantic: "2.5.0"

# Node.js (serveurs MCP)
node: ">=18.0.0"
@modelcontextprotocol/sdk: "^0.4.0"
```

### Configuration Partagée
- **Fichier principal**: `mcp-projects-shared-config.yaml`
- **Script de sync**: `sync_mcp_projects_smithery.sh`
- **Environnements**: Production + Development

## 🚀 Déploiement

### Déploiement Automatique
```bash
# Synchroniser tous les projets
./sync_mcp_projects_smithery.sh

# Déployer le hub central
cd mcp-hub-central && ./deploy_to_public_server.sh

# Déployer Supabase MCP
cd ng-supabase-mcp && ./scripts/deploy-selfhosted.sh

# Déployer Minecraft MCP
cd Minecraft-MCP-Forge-1.6.4 && ./deploy-railway.sh
```

### Variables d'Environnement
```bash
# Hub Central
PORT=8080
MCP_HUB_VERSION=3.7.0

# Supabase MCP
SUPABASE_URL=https://api.recube.gg/
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}

# Minecraft MCP
MINECRAFT_MCPC_VERSION=1.6.4
DOCKER_ENABLED=true
```

## 📊 Conformité Smithery.ai

### ✅ Standards Respectés

#### Supabase MCP Server
- **Format**: YAML (`smithery.yaml`)
- **Métadonnées**: Complètes
- **Outils**: 54 outils documentés
- **Exemples**: 3 exemples d'utilisation
- **Validation**: Schémas JSON valides

#### Minecraft MCP Server
- **Format**: JSON (`smithery-metadata.json`)
- **Métadonnées**: Complètes
- **Outils**: 4 outils spécialisés
- **Exemples**: 3 exemples d'utilisation
- **Validation**: Schémas JSON valides

### 🔍 Validation Qualité
- ✅ Champs requis présents
- ✅ Schémas d'entrée valides
- ✅ Exemples fonctionnels
- ✅ Documentation complète
- ✅ Versions synchronisées

## 🛠️ Outils Disponibles

### Supabase MCP (54 outils)
- **Base de données**: `execute_sql`, `list_tables`, `backup_database`
- **Authentification**: `create_auth_user`, `list_auth_users`, `manage_roles`
- **Stockage**: `list_storage_buckets`, `manage_storage_policies`
- **Migrations**: `create_migration`, `apply_migration`, `smart_migration`
- **Sécurité**: `audit_security`, `manage_rls_policies`
- **Monitoring**: `analyze_performance`, `metrics_dashboard`

### Minecraft MCP (4 outils)
- **Analyse**: `analyze_gui_spritesheet`
- **Export**: `export_slices`
- **Génération**: `generate_java_gui`
- **Prévisualisation**: `preview_layout`

## 📈 Monitoring et Maintenance

### Health Checks
- **Hub**: https://mcp.coupaul.fr/health
- **Supabase**: https://supabase.mcp.coupaul.fr/health
- **Minecraft**: https://minecraft.mcp.coupaul.fr/health

### Logs et Métriques
- **Format**: JSON structuré
- **Rotation**: Automatique
- **Niveau**: INFO par défaut
- **Export**: Prometheus

### Alertes
- **Webhook**: Slack intégré
- **Email**: admin@mcp.coupaul.fr
- **Seuils**: Échec + Récupération

## 🔄 Synchronisation et Maintenance

### Script de Synchronisation
```bash
# Exécuter la synchronisation complète
./sync_mcp_projects_smithery.sh
```

### Vérifications Automatiques
- ✅ Validation des configurations Smithery
- ✅ Synchronisation des versions
- ✅ Nettoyage des fichiers temporaires
- ✅ Génération de rapports

## 📚 Documentation

### Liens Utiles
- **Hub Central**: [Documentation complète](./HUB_CENTRAL_UPDATE_GUIDE.md)
- **Supabase MCP**: [README](./ng-supabase-mcp/README.md)
- **Minecraft MCP**: [Documentation](./Minecraft-MCP-Forge-1.6.4/DOCUMENTATION.md)

### Support
- **Issues**: [GitHub Issues](https://github.com/coupaul/mcp-hub-central/issues)
- **Discussions**: [GitHub Discussions](https://github.com/coupaul/mcp-hub-central/discussions)
- **Email**: admin@mcp.coupaul.fr

## 🎯 Prochaines Étapes

1. **Publication Smithery.ai**
   - Publier Supabase MCP Server
   - Publier Minecraft MCP Server
   - Valider les intégrations

2. **Optimisations**
   - Monitoring avancé
   - Cache intelligent
   - Performance tuning

3. **Extensions**
   - Nouveaux outils MCP
   - Intégrations supplémentaires
   - Documentation enrichie

---

## 📄 Licence

MIT License - Voir [LICENSE](./LICENSE) pour plus de détails.

## 👥 Contribution

Les contributions sont les bienvenues ! Voir [CONTRIBUTING.md](./CONTRIBUTING.md) pour les guidelines.

---

*Dernière mise à jour: 8 janvier 2025 - Version 3.7.0*