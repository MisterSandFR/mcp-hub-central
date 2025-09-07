# MCP Hub Central - Dockerfile
# Image Docker optimisée pour le Hub Multi-Serveurs MCP

FROM python:3.11-slim

# Métadonnées
LABEL maintainer="coupaul <support@mcp.coupaul.fr>"
LABEL description="MCP Hub Central - Centre de contrôle unifié pour tous les serveurs MCP"
LABEL version="1.0.0"

# Variables d'environnement
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PORT=8000
ENV MCP_HUB_VERSION=1.0.0

# Créer un utilisateur non-root pour la sécurité
RUN groupadd -r mcpuser && useradd -r -g mcpuser mcpuser

# Créer le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration
COPY mcp_hub_central.py /app/
COPY mcp_servers_config.json /app/
COPY requirements.txt /app/

# Installer les dépendances Python (optionnelles)
RUN pip install --no-cache-dir -r requirements.txt || echo "Dependencies installation skipped - using standard library only"

# Créer les répertoires nécessaires
RUN mkdir -p /app/logs /app/config /app/data

# Changer les permissions
RUN chown -R mcpuser:mcpuser /app

# Passer à l'utilisateur non-root
USER mcpuser

# Exposer le port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Commande de démarrage
CMD ["python", "mcp_hub_central.py"]

# Métadonnées supplémentaires
LABEL org.opencontainers.image.title="MCP Hub Central"
LABEL org.opencontainers.image.description="Centre de contrôle unifié pour tous les serveurs MCP"
LABEL org.opencontainers.image.url="https://github.com/coupaul/mcp-hub-central"
LABEL org.opencontainers.image.source="https://github.com/coupaul/mcp-hub-central"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="2024-01-01T00:00:00Z"
LABEL org.opencontainers.image.licenses="MIT"
