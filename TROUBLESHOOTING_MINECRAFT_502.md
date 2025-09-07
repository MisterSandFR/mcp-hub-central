# 🚨 Guide de Dépannage - Serveur Minecraft MCPC+ 1.6.4

## Problème Identifié
**Erreur 502 systématique** sur tous les endpoints du serveur Minecraft MCPC+ 1.6.4 déployé sur Railway.

## Analyse des Logs
```
Sep 7, 2025, 10:37 PM
GET / → 502 (1-277ms)
GET /health → 502 (1ms)
GET /api/tools → 502 (1ms)
GET /mcp → 502 (1ms)
GET /.well-known/mcp-config → 502 (1ms)
GET /mcp/info → 502 (1ms)
GET /mcp/tools → 502 (2ms)
```

## Diagnostic
- **Problème** : Application non démarrée correctement
- **Cause** : Erreur de configuration ou de démarrage
- **Temps de réponse** : Très rapide (1-277ms) = erreur immédiate

## Causes Possibles

### 1. Configuration Railway
- ❌ Port 3000 non exposé dans `railway.json`
- ❌ Variables d'environnement manquantes
- ❌ Buildpack ou Dockerfile incorrect

### 2. Code de l'Application
- ❌ Serveur HTTP ne démarre pas sur le port 3000
- ❌ Erreur dans le code de démarrage
- ❌ Dépendances manquantes
- ❌ Gestion des erreurs incorrecte

### 3. Configuration Docker
- ❌ Dockerfile incorrect
- ❌ Port non exposé dans le conteneur
- ❌ Commande de démarrage incorrecte

## Solutions Recommandées

### Étape 1: Vérifier la Configuration Railway

**1.1. Vérifier le fichier `railway.json`:**
```json
{
  "deploy": {
    "startCommand": "npm start",
    "healthcheckPath": "/health",
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE"
  }
}
```

**1.2. Vérifier les variables d'environnement:**
```bash
railway variables
```

**1.3. Vérifier le port exposé:**
```bash
railway status
```

### Étape 2: Vérifier le Code de l'Application

**2.1. Vérifier que le serveur démarre sur le port 3000:**
```javascript
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Serveur HTTP démarré sur le port ${PORT}`);
});
```

**2.2. Vérifier les endpoints:**
```javascript
// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'UP', timestamp: new Date().toISOString() });
});

// API des outils
app.get('/api/tools', (req, res) => {
  res.json(tools);
});

// Endpoint MCP
app.post('/mcp', (req, res) => {
  // Logique MCP
});
```

**2.3. Vérifier la gestion des erreurs:**
```javascript
app.use((err, req, res, next) => {
  console.error('Erreur:', err);
  res.status(500).json({ error: 'Erreur interne du serveur' });
});
```

### Étape 3: Tester Localement

**3.1. Build et test Docker:**
```bash
# Build de l'image
docker build -t minecraft-mcp .

# Test local
docker run -p 3000:3000 minecraft-mcp

# Vérifier que l'application démarre
curl http://localhost:3000/health
```

**3.2. Test des endpoints:**
```bash
# Health check
curl http://localhost:3000/health

# API des outils
curl http://localhost:3000/api/tools

# Endpoint MCP
curl -X POST http://localhost:3000/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"ping","id":1}'
```

### Étape 4: Redéployer sur Railway

**4.1. Redéployer avec logs:**
```bash
# Redéployer
railway up --detach

# Suivre les logs
railway logs --follow
```

**4.2. Vérifier le statut:**
```bash
railway status
```

## Commandes de Debug

### Railway
```bash
# Logs en temps réel
railway logs --follow

# Statut du service
railway status

# Variables d'environnement
railway variables

# Redéployer
railway up
```

### Local
```bash
# Test Docker
docker run -p 3000:3000 [image]

# Test des endpoints
curl http://localhost:3000/health
curl http://localhost:3000/api/tools
```

## Checklist de Vérification

- [ ] Port 3000 exposé dans `railway.json`
- [ ] Variables d'environnement configurées
- [ ] Serveur HTTP démarre sur le port 3000
- [ ] Endpoints `/health`, `/api/tools`, `/mcp` fonctionnels
- [ ] Gestion des erreurs correcte
- [ ] Dockerfile correct
- [ ] Test local réussi
- [ ] Redéploiement Railway réussi

## Message pour le Développeur

---

**🚨 PROBLÈME CRITIQUE DÉTECTÉ**

Le serveur Minecraft MCPC+ 1.6.4 retourne des erreurs 502 sur tous les endpoints. L'application ne démarre pas correctement sur Railway.

**Actions immédiates requises:**

1. **Vérifier les logs Railway:**
   ```bash
   railway logs --follow
   ```

2. **Vérifier la configuration du port 3000:**
   - Port exposé dans `railway.json`
   - Serveur démarre sur le port 3000

3. **Tester localement avec Docker:**
   ```bash
   docker build -t minecraft-mcp .
   docker run -p 3000:3000 minecraft-mcp
   ```

4. **Redéployer après correction:**
   ```bash
   railway up
   ```

**Le problème n'est pas lié au hub central mais au démarrage de l'application elle-même.**

---

## Prochaines Étapes

Une fois le problème résolu:

1. **Tester la connectivité:**
   ```bash
   curl https://minecraft.mcp.coupaul.fr/health
   ```

2. **Vérifier l'intégration avec le hub central:**
   - Le hub central détectera automatiquement le serveur
   - Les outils MCP seront disponibles

3. **Confirmer le fonctionnement:**
   - Tous les endpoints répondent correctement
   - Le serveur est opérationnel

**Le serveur sera automatiquement intégré au hub central une fois opérationnel !** 🎮
