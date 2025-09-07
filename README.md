# MCP Hub Central

🚀 **Hub Central Multi-Serveurs MCP** - Centre de contrôle unifié pour tous vos serveurs MCP

## 🌟 Fonctionnalités

- 🔍 **Découverte automatique** des serveurs MCP
- 🧠 **Routage intelligent** basé sur les capacités
- ⚖️ **Load balancing** automatique
- 📊 **Monitoring centralisé** de tous les serveurs
- 🌐 **Interface web unifiée** moderne
- 🔒 **Sécurité avancée** avec authentification
- 📈 **Métriques en temps réel**

## 🏗️ Architecture

```
mcp.coupaul.fr (Hub Central)
├── 🔍 Découverte automatique
├── 🧠 Routage intelligent
├── ⚖️ Load balancing
├── 📊 Monitoring
└── 🌐 Interface unifiée
    ├── supabase.mcp.coupaul.fr → Supabase MCP Server
    ├── files.mcp.coupaul.fr → File Manager MCP Server
    ├── git.mcp.coupaul.fr → Git MCP Server
    ├── web.mcp.coupaul.fr → Web Scraping MCP Server
    └── minecraft.mcp.coupaul.fr → Minecraft MCP Server
```

## 🚀 Démarrage Rapide

### Prérequis
- Python 3.8+
- Docker & Docker Compose (optionnel)

### Installation

```bash
# Cloner le repository
git clone https://github.com/MisterSandFR/mcp-hub-central.git
cd mcp-hub-central

# Installer les dépendances
pip install -r requirements.txt

# Configurer les serveurs MCP
cp mcp_servers_config.example.json mcp_servers_config.json
# Éditer mcp_servers_config.json avec vos serveurs

# Démarrer le Hub
python mcp_hub_central.py
```

### Avec Docker

```bash
# Démarrer tous les services
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

## ⚙️ Configuration

### Serveurs MCP Supportés

Le Hub peut découvrir et router vers :

- **Supabase MCP Server** : Gestion complète de Supabase
- **File Manager MCP** : Gestion de fichiers avancée
- **Git MCP Server** : Gestion de repositories Git
- **Web Scraping MCP** : Scraping et extraction de données
- **Minecraft MCP Server** : Gestion et automatisation de serveurs Minecraft
- **Custom MCP Servers** : Serveurs personnalisés

### Configuration des Serveurs

```json
{
  "servers": {
    "supabase": {
      "name": "Supabase MCP Server",
      "version": "3.1.0",
      "host": "supabase-mcp-server",
      "port": 8001,
      "path": "/supabase",
      "categories": ["database", "auth", "storage"],
      "status": "active"
    }
  }
}
```

## 🔧 API Endpoints

### Hub Central
- `GET /` - Interface web principale
- `GET /health` - Health check du hub
- `GET /api/servers` - Liste des serveurs découverts
- `GET /api/discovery` - État de la découverte
- `GET /api/metrics` - Métriques en temps réel

### Routage Intelligent
- `POST /mcp` - Routage automatique vers le bon serveur
- `GET /.well-known/mcp-config` - Configuration MCP pour Smithery

## 📊 Monitoring

Le Hub fournit un monitoring complet :

- **Statut des serveurs** en temps réel
- **Métriques de performance** par serveur
- **Logs centralisés** de tous les serveurs
- **Alertes automatiques** en cas de problème

## 🔒 Sécurité

- **Authentification JWT** pour l'accès aux serveurs
- **Rate limiting** par IP et utilisateur
- **Chiffrement HTTPS** obligatoire
- **Audit logs** de toutes les opérations

## 🚀 Déploiement

### Railway (Recommandé)
```bash
# Déployer sur Railway
railway login
railway init
railway up
```

### Docker
```bash
# Build et déploiement
docker build -t mcp-hub-central .
docker run -p 8000:8000 mcp-hub-central
```

### Kubernetes
```bash
# Déploiement K8s
kubectl apply -f k8s/
```

## 🤝 Contribution

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- [Smithery](https://smithery.ai) pour l'écosystème MCP
- [Supabase](https://supabase.com) pour l'inspiration
- La communauté MCP pour les contributions

## 📞 Support

- 📧 Email : support@mcp.coupaul.fr
- 💬 Discord : [Serveur MCP Community](https://discord.gg/mcp)
- 🐛 Issues : [GitHub Issues](https://github.com/MisterSandFR/mcp-hub-central/issues)

---

**Fait avec ❤️ par [MisterSandFR](https://github.com/MisterSandFR)**
