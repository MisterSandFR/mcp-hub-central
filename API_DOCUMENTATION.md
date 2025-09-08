# 📚 Documentation API MCP Hub Central

## 🎯 Vue d'ensemble

Cette documentation couvre l'API complète de l'écosystème MCP Hub Central, incluant le hub central et les deux serveurs MCP spécialisés.

### 🏗️ Architecture

```
MCP Hub Central
├── 🎯 Hub Central (Port 8080)
├── 🗄️ Supabase MCP Server (Port 8000)
└── 🎮 Minecraft MCP Server (Port 3000)
```

## 🌐 Endpoints Communs

### Health Check
```http
GET /health
```

**Description**: Vérifie l'état de santé du service

**Réponse**:
```json
{
  "status": "healthy",
  "timestamp": "2025-01-08T12:00:00Z",
  "version": "3.7.0",
  "uptime": "72h15m30s"
}
```

### MCP Endpoint
```http
GET /mcp
```

**Description**: Point d'entrée principal pour les clients MCP

**Réponse**:
```json
{
  "protocol": "mcp",
  "version": "1.0",
  "capabilities": {
    "tools": true,
    "resources": false,
    "prompts": false
  },
  "server": {
    "name": "mcp-server-name",
    "version": "3.7.0"
  }
}
```

### Tools API
```http
GET /api/tools
```

**Description**: Liste tous les outils MCP disponibles

**Réponse**:
```json
{
  "tools": [
    {
      "name": "tool_name",
      "description": "Description de l'outil",
      "inputSchema": {
        "type": "object",
        "properties": {
          "param1": {
            "type": "string",
            "description": "Description du paramètre"
          }
        },
        "required": ["param1"]
      }
    }
  ],
  "total": 58
}
```

## 🎯 Hub Central API

### Base URL
```
https://mcp.coupaul.fr
```

### Endpoints Spécifiques

#### Liste des Serveurs
```http
GET /api/servers
```

**Description**: Liste tous les serveurs MCP connectés

**Réponse**:
```json
{
  "servers": [
    {
      "id": "supabase-mcp",
      "name": "Supabase MCP Server",
      "url": "https://supabase.mcp.coupaul.fr",
      "status": "online",
      "tools_count": 54,
      "last_seen": "2025-01-08T12:00:00Z"
    },
    {
      "id": "minecraft-mcp",
      "name": "Minecraft MCP Server",
      "url": "https://minecraft.mcp.coupaul.fr",
      "status": "online",
      "tools_count": 4,
      "last_seen": "2025-01-08T12:00:00Z"
    }
  ]
}
```

#### Configuration MCP
```http
GET /.well-known/mcp-config
```

**Description**: Configuration MCP standardisée

**Réponse**:
```json
{
  "mcpServers": {
    "supabase-mcp": {
      "command": "node",
      "args": ["server/dist/index.js"],
      "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}"
      }
    },
    "minecraft-mcp": {
      "command": "node",
      "args": ["server/dist/index.js"],
      "env": {
        "MINECRAFT_MCPC_VERSION": "1.6.4"
      }
    }
  }
}
```

## 🗄️ Supabase MCP Server API

### Base URL
```
https://supabase.mcp.coupaul.fr
```

### Outils Disponibles (54 outils)

#### Base de Données

##### Exécuter une requête SQL
```json
{
  "name": "execute_sql",
  "description": "Exécute une requête SQL sur la base de données Supabase",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "Requête SQL à exécuter"
      },
      "database": {
        "type": "string",
        "description": "Nom de la base de données",
        "default": "postgres"
      }
    },
    "required": ["query"]
  }
}
```

##### Lister les tables
```json
{
  "name": "list_tables",
  "description": "Liste toutes les tables de la base de données",
  "inputSchema": {
    "type": "object",
    "properties": {
      "schema": {
        "type": "string",
        "description": "Schéma à interroger",
        "default": "public"
      }
    }
  }
}
```

#### Authentification

##### Créer un utilisateur
```json
{
  "name": "create_auth_user",
  "description": "Crée un nouvel utilisateur dans l'authentification Supabase",
  "inputSchema": {
    "type": "object",
    "properties": {
      "email": {
        "type": "string",
        "description": "Email de l'utilisateur"
      },
      "password": {
        "type": "string",
        "description": "Mot de passe de l'utilisateur"
      },
      "email_confirm": {
        "type": "boolean",
        "description": "Confirmer l'email automatiquement",
        "default": false
      }
    },
    "required": ["email", "password"]
  }
}
```

##### Lister les utilisateurs
```json
{
  "name": "list_auth_users",
  "description": "Liste tous les utilisateurs authentifiés",
  "inputSchema": {
    "type": "object",
    "properties": {
      "page": {
        "type": "number",
        "description": "Numéro de page",
        "default": 1
      },
      "per_page": {
        "type": "number",
        "description": "Nombre d'utilisateurs par page",
        "default": 50
      }
    }
  }
}
```

#### Stockage

##### Lister les buckets
```json
{
  "name": "list_storage_buckets",
  "description": "Liste tous les buckets de stockage",
  "inputSchema": {
    "type": "object",
    "properties": {}
  }
}
```

#### Migrations

##### Créer une migration
```json
{
  "name": "create_migration",
  "description": "Crée une nouvelle migration de base de données",
  "inputSchema": {
    "type": "object",
    "properties": {
      "name": {
        "type": "string",
        "description": "Nom de la migration"
      },
      "sql": {
        "type": "string",
        "description": "SQL de la migration"
      }
    },
    "required": ["name", "sql"]
  }
}
```

## 🎮 Minecraft MCP Server API

### Base URL
```
https://minecraft.mcp.coupaul.fr
```

### Outils Disponibles (4 outils)

#### Analyser une spritesheet GUI
```json
{
  "name": "analyze_gui_spritesheet",
  "description": "Analyse une spritesheet GUI PNG et génère un atlas.json",
  "inputSchema": {
    "type": "object",
    "properties": {
      "image": {
        "type": "string",
        "description": "Chemin vers le fichier PNG de la spritesheet GUI"
      },
      "hints": {
        "type": "object",
        "description": "Indices optionnels pour l'analyse",
        "properties": {
          "minSpriteSize": {
            "type": "number",
            "description": "Taille minimale d'un sprite en pixels",
            "default": 16
          },
          "maxSprites": {
            "type": "number",
            "description": "Nombre maximum de sprites à détecter",
            "default": 100
          },
          "detectStates": {
            "type": "boolean",
            "description": "Détecter automatiquement les états",
            "default": true
          }
        }
      }
    },
    "required": ["image"]
  }
}
```

#### Exporter les sprites
```json
{
  "name": "export_slices",
  "description": "Exporte les sprites découpés ou crée un atlas packé",
  "inputSchema": {
    "type": "object",
    "properties": {
      "atlas": {
        "type": "string",
        "description": "Chemin vers le fichier atlas.json généré"
      },
      "packing": {
        "type": "object",
        "description": "Options de packing pour l'export",
        "properties": {
          "outputDir": {
            "type": "string",
            "description": "Dossier de sortie pour les sprites",
            "default": "./exported_sprites"
          },
          "packMode": {
            "type": "string",
            "enum": ["individual", "atlas"],
            "description": "Mode d'export",
            "default": "individual"
          },
          "maxAtlasSize": {
            "type": "number",
            "description": "Taille maximale de l'atlas en pixels",
            "default": 1024
          }
        }
      }
    },
    "required": ["atlas"]
  }
}
```

#### Générer du code Java
```json
{
  "name": "generate_java_gui",
  "description": "Génère du code Java 7 compatible avec Forge 1.6.4",
  "inputSchema": {
    "type": "object",
    "properties": {
      "atlas": {
        "type": "string",
        "description": "Chemin vers le fichier atlas.json"
      },
      "target": {
        "type": "string",
        "description": "Version cible",
        "default": "forge-1.6.4"
      },
      "package": {
        "type": "string",
        "description": "Package Java pour les classes générées"
      },
      "screenName": {
        "type": "string",
        "description": "Nom de la classe d'écran principale"
      }
    },
    "required": ["atlas", "package", "screenName"]
  }
}
```

#### Prévisualiser le layout
```json
{
  "name": "preview_layout",
  "description": "Crée une prévisualisation PNG du layout GUI",
  "inputSchema": {
    "type": "object",
    "properties": {
      "atlas": {
        "type": "string",
        "description": "Chemin vers le fichier atlas.json"
      },
      "layout": {
        "type": "object",
        "description": "Configuration du layout",
        "properties": {
          "width": {
            "type": "number",
            "description": "Largeur de la prévisualisation",
            "default": 800
          },
          "height": {
            "type": "number",
            "description": "Hauteur de la prévisualisation",
            "default": 600
          },
          "showBounds": {
            "type": "boolean",
            "description": "Afficher les bordures des sprites",
            "default": true
          },
          "showLabels": {
            "type": "boolean",
            "description": "Afficher les noms des sprites",
            "default": true
          }
        }
      }
    },
    "required": ["atlas"]
  }
}
```

## 🔧 Codes d'Erreur

### Codes HTTP Standards
- `200` - Succès
- `400` - Requête invalide
- `401` - Non autorisé
- `404` - Non trouvé
- `500` - Erreur serveur interne

### Codes d'Erreur MCP
- `MCP_ERROR_INVALID_PARAMS` - Paramètres invalides
- `MCP_ERROR_TOOL_NOT_FOUND` - Outil non trouvé
- `MCP_ERROR_EXECUTION_FAILED` - Échec d'exécution
- `MCP_ERROR_PERMISSION_DENIED` - Permission refusée

## 📊 Limites et Quotas

### Limites par Endpoint
- **Health Check**: 100 req/min
- **MCP Endpoint**: 1000 req/min
- **Tools API**: 500 req/min

### Limites par Outil
- **Supabase MCP**: 1000 exécutions/jour
- **Minecraft MCP**: 500 exécutions/jour

## 🔐 Authentification

### Clés API
```http
Authorization: Bearer YOUR_API_KEY
```

### Variables d'Environnement
```bash
# Supabase MCP
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Minecraft MCP
MINECRAFT_MCPC_VERSION=1.6.4
DOCKER_ENABLED=true
```

## 📈 Monitoring et Métriques

### Métriques Disponibles
- Temps de réponse moyen
- Taux d'erreur
- Nombre de requêtes par minute
- Utilisation des outils

### Endpoints de Monitoring
```http
GET /metrics          # Métriques Prometheus
GET /health/detailed  # Santé détaillée
GET /stats            # Statistiques d'utilisation
```

## 🚀 Exemples d'Utilisation

### Exemple avec cURL
```bash
# Health check
curl -X GET https://mcp.coupaul.fr/health

# Lister les outils
curl -X GET https://supabase.mcp.coupaul.fr/api/tools

# Exécuter un outil Supabase
curl -X POST https://supabase.mcp.coupaul.fr/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "method": "tools/call",
    "params": {
      "name": "execute_sql",
      "arguments": {
        "query": "SELECT * FROM users LIMIT 10"
      }
    }
  }'
```

### Exemple avec JavaScript
```javascript
// Client MCP simple
const mcpClient = {
  async callTool(serverUrl, toolName, args) {
    const response = await fetch(`${serverUrl}/mcp`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        method: 'tools/call',
        params: {
          name: toolName,
          arguments: args
        }
      })
    });
    return response.json();
  }
};

// Utilisation
const result = await mcpClient.callTool(
  'https://supabase.mcp.coupaul.fr',
  'execute_sql',
  { query: 'SELECT * FROM users LIMIT 10' }
);
```

---

*Documentation API MCP Hub Central v3.7.0 - Dernière mise à jour: 8 janvier 2025*

