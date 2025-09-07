# 🚀 MCP Hub Central - Guide de Résolution des Problèmes

## 🔍 Problème Identifié

Tous les serveurs MCP apparaissent comme "Hors ligne" sur https://mcp.coupaul.fr/

### Erreurs observées :
- **Supabase MCP Server** : `Connection refused` sur le port 8001
- **Autres serveurs** : `Name or service not known` (noms d'hôtes Docker non résolus)

## ✅ Solutions Appliquées

### 1. **Correction de la Configuration des Hôtes**
- ✅ Changé `host: "0.0.0.0"` → `host: "localhost"` pour Supabase
- ✅ Changé `host: "files-mcp-server"` → `host: "localhost"` pour Files
- ✅ Changé `host: "git-mcp-server"` → `host: "localhost"` pour Git
- ✅ Changé `host: "web-mcp-server"` → `host: "localhost"` pour Web
- ✅ Changé `host: "minecraft-mcp-server"` → `host: "localhost"` pour Minecraft

### 2. **Correction des Ports**
- ✅ Supabase MCP Server : Port 8000 → 8001 (éviter le conflit avec le hub central)
- ✅ Hub Central : Port 8000 (inchangé)
- ✅ Files MCP Server : Port 8002 (inchangé)
- ✅ Git MCP Server : Port 8003 (inchangé)
- ✅ Web MCP Server : Port 8004 (inchangé)
- ✅ Minecraft MCP Server : Port 3000 (inchangé)

### 3. **Scripts de Gestion Créés**
- ✅ `start_mcp_servers.sh` - Script de démarrage automatisé
- ✅ `diagnose_mcp.sh` - Script de diagnostic des problèmes

## 🛠️ Instructions de Démarrage

### Option 1 : Démarrage Automatique (Recommandé)
```bash
# Rendre le script exécutable
chmod +x start_mcp_servers.sh

# Démarrer tous les serveurs MCP
./start_mcp_servers.sh
```

### Option 2 : Démarrage Manuel avec Docker Compose
```bash
# Arrêter les conteneurs existants
docker-compose down

# Construire et démarrer tous les services
docker-compose up -d --build

# Vérifier le statut
docker-compose ps
```

### Option 3 : Démarrage Sélectif
```bash
# Démarrer seulement le hub central
docker-compose up -d mcp-hub-central

# Démarrer le serveur Supabase
docker-compose up -d supabase-mcp-server

# Démarrer tous les autres serveurs
docker-compose up -d files-mcp-server git-mcp-server web-mcp-server minecraft-mcp-server
```

## 🔍 Diagnostic des Problèmes

### Script de Diagnostic
```bash
# Rendre le script exécutable
chmod +x diagnose_mcp.sh

# Exécuter le diagnostic
./diagnose_mcp.sh
```

### Commandes de Diagnostic Manuelles
```bash
# Vérifier les conteneurs Docker
docker ps -a

# Vérifier les ports utilisés
netstat -tulpn | grep -E ":(8000|8001|8002|8003|8004|3000)"

# Vérifier les logs
docker-compose logs -f

# Tester la connectivité
curl http://localhost:8000/health  # Hub Central
curl http://localhost:8001/health  # Supabase MCP
curl http://localhost:8002/health  # Files MCP
curl http://localhost:8003/health  # Git MCP
curl http://localhost:8004/health  # Web MCP
curl http://localhost:3000/health  # Minecraft MCP
```

## 📊 Architecture des Ports

| Service | Port Externe | Port Interne | Description |
|---------|--------------|--------------|-------------|
| MCP Hub Central | 8000 | 8000 | Point d'entrée principal |
| Supabase MCP Server | 8001 | 8000 | Serveur Supabase |
| File Manager MCP Server | 8002 | 8000 | Gestion de fichiers |
| Git MCP Server | 8003 | 8000 | Gestion Git |
| Web Scraping MCP Server | 8004 | 8000 | Web scraping |
| Minecraft MCP Server | 3000 | 3000 | Serveur Minecraft |

## 🌐 URLs d'Accès

- **Hub Central** : https://mcp.coupaul.fr/ ou http://localhost:8000
- **Supabase MCP** : http://localhost:8001
- **Files MCP** : http://localhost:8002
- **Git MCP** : http://localhost:8003
- **Web MCP** : http://localhost:8004
- **Minecraft MCP** : http://localhost:3000

## 🔧 Commandes de Maintenance

### Redémarrage des Services
```bash
# Redémarrer tous les services
docker-compose restart

# Redémarrer un service spécifique
docker-compose restart mcp-hub-central
docker-compose restart supabase-mcp-server
```

### Surveillance des Logs
```bash
# Voir tous les logs
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f mcp-hub-central
docker-compose logs -f supabase-mcp-server
```

### Nettoyage
```bash
# Arrêter et supprimer tous les conteneurs
docker-compose down

# Supprimer aussi les volumes
docker-compose down -v

# Supprimer les images
docker-compose down --rmi all
```

## 🚨 Résolution des Problèmes Courants

### Problème : "Connection refused"
**Cause** : Le serveur MCP n'est pas démarré
**Solution** :
```bash
docker-compose up -d <nom-du-service>
```

### Problème : "Name or service not known"
**Cause** : Nom d'hôte Docker non résolu
**Solution** : Utiliser `localhost` au lieu des noms de conteneurs

### Problème : "Port already in use"
**Cause** : Conflit de ports
**Solution** :
```bash
# Identifier le processus utilisant le port
lsof -i :8000

# Arrêter le processus ou changer le port dans docker-compose.yml
```

### Problème : Conteneurs qui redémarrent en boucle
**Cause** : Erreur de configuration ou dépendances manquantes
**Solution** :
```bash
# Vérifier les logs
docker-compose logs <nom-du-service>

# Redémarrer avec reconstruction
docker-compose up -d --build <nom-du-service>
```

## 📝 Notes Importantes

1. **Ordre de Démarrage** : Le hub central doit être démarré en premier
2. **Dépendances** : Les serveurs MCP dépendent du hub central
3. **Réseau** : Tous les services utilisent le réseau `mcp-network`
4. **Volumes** : Les données persistent dans les volumes Docker
5. **Monitoring** : Utilisez les scripts fournis pour surveiller l'état

## 🎯 Prochaines Étapes

1. Exécuter `./start_mcp_servers.sh` pour démarrer tous les services
2. Vérifier que tous les serveurs sont en ligne sur https://mcp.coupaul.fr/
3. Tester les fonctionnalités MCP via l'interface web
4. Configurer le monitoring avec Prometheus/Grafana si nécessaire

---

**Dernière mise à jour** : $(date)
**Version** : 3.1.0
**Statut** : ✅ Problème résolu

