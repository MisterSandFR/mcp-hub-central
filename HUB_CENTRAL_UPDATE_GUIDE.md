# 🔧 Guide de Mise à Jour du Hub Central Public

## Problème Identifié

Le hub central public https://mcp.coupaul.fr ne détecte pas le serveur Minecraft MCPC+ 1.6.4 qui est pourtant parfaitement opérationnel sur https://minecraft.mcp.coupaul.fr.

## Configuration Actuelle (Problématique)

```json
{
  "mcpServers": {
    "supabase-mcp": {
      "command": "python",
      "args": ["mcp_hub.py"],
      "env": {
        "MCP_SERVER_NAME": "Supabase MCP Server",
        "MCP_SERVER_VERSION": "3.1.0"
      }
    }
  }
}
```

**Problème :** Seul le serveur Supabase est configuré, le serveur Minecraft est absent.

## Configuration Requise (Solution)

```json
{
  "mcpServers": {
    "supabase-mcp": {
      "command": "python",
      "args": ["mcp_hub.py"],
      "env": {
        "MCP_SERVER_NAME": "Supabase MCP Server",
        "MCP_SERVER_VERSION": "3.1.0"
      }
    },
    "minecraft-mcpc-1.6.4": {
      "command": "python",
      "args": ["minecraft_mcp_server.py"],
      "env": {
        "MCP_SERVER_NAME": "Minecraft MCPC+ 1.6.4 Server",
        "MCP_SERVER_VERSION": "1.0.0",
        "MINECRAFT_MCP_URL": "https://minecraft.mcp.coupaul.fr"
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
    "url": "https://mcp.coupaul.fr/mcp",
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
        "url": "https://supabase.mcp.coupaul.fr",
        "status": "online"
      },
      {
        "id": "minecraft-mcpc-1.6.4",
        "name": "Minecraft MCPC+ 1.6.4 Server",
        "url": "https://minecraft.mcp.coupaul.fr",
        "status": "online"
      }
    ]
  }
}
```

## Méthodes de Mise à Jour

### 1. 🎯 Méthode Recommandée : Contact Administrateur

**Actions :**
1. Contacter l'administrateur du hub central public
2. Fournir le fichier `hub_central_update_config.json`
3. Demander la mise à jour de la configuration

**Message Type :**
```
Objet: Mise à jour configuration MCP Hub Central

Bonjour,

Le hub central public https://mcp.coupaul.fr ne détecte pas le serveur
Minecraft MCPC+ 1.6.4 qui est pourtant opérationnel sur:
https://minecraft.mcp.coupaul.fr

Pouvez-vous mettre à jour la configuration du hub central pour inclure
le serveur Minecraft ?

Configuration requise jointe: hub_central_update_config.json

Cordialement
```

### 2. 🔧 Méthode Technique : Accès Direct

**Si vous avez accès au serveur :**

1. **Localiser le fichier de configuration :**
   ```bash
   find / -name "*.json" -path "*mcp*" 2>/dev/null
   ```

2. **Sauvegarder la configuration actuelle :**
   ```bash
   cp current_config.json current_config.json.backup
   ```

3. **Remplacer par la nouvelle configuration :**
   ```bash
   cp hub_central_update_config.json current_config.json
   ```

4. **Redémarrer le service :**
   ```bash
   systemctl restart mcp-hub-central
   # ou
   docker-compose restart mcp-hub-central
   ```

### 3. 📝 Méthode Documentation : Guide Complet

**Créer un guide de mise à jour pour l'administrateur :**

1. **Documenter les étapes**
2. **Fournir les fichiers de configuration**
3. **Inclure les commandes de vérification**

## Vérification Post-Mise à Jour

Après la mise à jour, vérifier que tout fonctionne :

```bash
# Vérifier la configuration MCP
curl -s https://mcp.coupaul.fr/.well-known/mcp-config

# Vérifier les serveurs détectés
curl -s https://mcp.coupaul.fr/api/servers

# Vérifier les outils disponibles
curl -s https://mcp.coupaul.fr/api/tools

# Vérifier le health check
curl -s https://mcp.coupaul.fr/health
```

**Résultats attendus :**
- ✅ 2 serveurs détectés (Supabase + Minecraft)
- ✅ 51+ outils au total (47 Supabase + 4 Minecraft)
- ✅ Serveur Minecraft visible dans l'interface

## Solution Temporaire

En attendant la mise à jour du hub central public :

**Utilisez les serveurs individuels directement :**
- 🎮 **Serveur Minecraft** : https://minecraft.mcp.coupaul.fr
- 🗄️ **Serveur Supabase** : https://supabase.mcp.coupaul.fr

**Avantages :**
- ✅ Informations correctes et à jour
- ✅ Tous les outils disponibles
- ✅ Performance optimale
- ✅ Aucune dépendance au hub central

## Fichiers Générés

- `hub_central_update_config.json` - Configuration complète
- `update_hub_central_public.sh` - Script de mise à jour
- `HUB_CENTRAL_UPDATE_GUIDE.md` - Ce guide

## Contact

Pour toute question concernant cette mise à jour :
- **Serveur Minecraft** : https://minecraft.mcp.coupaul.fr
- **Serveur Supabase** : https://supabase.mcp.coupaul.fr
- **Hub Central** : https://mcp.coupaul.fr

---

**Note :** Le serveur Minecraft MCPC+ 1.6.4 est parfaitement opérationnel et prêt à être intégré au hub central public. La mise à jour permettra d'avoir une vue d'ensemble complète de tous les serveurs MCP disponibles.
