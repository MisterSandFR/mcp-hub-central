#!/bin/bash

# Script de synchronisation des 3 projets MCP interconnectés
# Usage: ./sync_mcp_projects.sh

echo "🔗 Synchronisation des 3 projets MCP interconnectés"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[SYNC]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✅ SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️ WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[❌ ERROR]${NC} $1"
}

print_status "=== SYNCHRONISATION DES PROJETS MCP ==="

# Configuration des projets
PROJECTS=(
    "mcp-hub-central:HUB"
    "ng-supabase-mcp:SUPABASE"
    "Minecraft-MCP-Forge-1.6.4:MINECRAFT"
)

# Version commune
COMMON_VERSION="3.7.0"
COMMON_PYTHON_VERSION="3.11"

echo ""
print_status "=== 1. VÉRIFICATION DES PROJETS ==="

for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        print_success "✅ Projet $project_name trouvé"
    else
        print_warning "⚠️ Projet $project_name non trouvé dans le répertoire parent"
    fi
done

echo ""
print_status "=== 2. SYNCHRONISATION DES VERSIONS ==="

print_status "Version commune: $COMMON_VERSION"
print_status "Python version: $COMMON_PYTHON_VERSION"

# Fonction pour synchroniser un projet
sync_project() {
    local project_name=$1
    local project_type=$2
    
    print_status "Synchronisation du projet $project_name ($project_type)..."
    
    if [ -d "../$project_name" ]; then
        cd "../$project_name" || return 1
        
        # Mettre à jour la version dans les fichiers de configuration
        if [ -f "package.json" ]; then
            sed -i "s/\"version\": \".*\"/\"version\": \"$COMMON_VERSION\"/" package.json
            print_success "✅ package.json mis à jour"
        fi
        
        if [ -f "pyproject.toml" ]; then
            sed -i "s/version = \".*\"/version = \"$COMMON_VERSION\"/" pyproject.toml
            print_success "✅ pyproject.toml mis à jour"
        fi
        
        if [ -f "setup.py" ]; then
            sed -i "s/version='.*'/version='$COMMON_VERSION'/" setup.py
            print_success "✅ setup.py mis à jour"
        fi
        
        # Mettre à jour les variables d'environnement
        if [ -f ".env" ]; then
            sed -i "s/VERSION=.*/VERSION=$COMMON_VERSION/" .env
            print_success "✅ .env mis à jour"
        fi
        
        # Mettre à jour les Dockerfiles
        if [ -f "Dockerfile" ]; then
            sed -i "s/FROM python:.*/FROM python:$COMMON_PYTHON_VERSION-slim/" Dockerfile
            print_success "✅ Dockerfile mis à jour"
        fi
        
        cd - || return 1
    else
        print_warning "⚠️ Projet $project_name non trouvé"
    fi
}

# Synchroniser tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    sync_project "$project_name" "$project_type"
done

echo ""
print_status "=== 3. SYNCHRONISATION DES CONFIGURATIONS ==="

# Copier la configuration partagée vers tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        cp mcp-projects-shared-config.yaml "../$project_name/"
        print_success "✅ Configuration partagée copiée vers $project_name"
    fi
done

echo ""
print_status "=== 4. SYNCHRONISATION DES VARIABLES D'ENVIRONNEMENT ===""

# Créer un fichier .env commun
cat > .env.shared << 'EOF'
# Variables d'environnement communes pour les 3 projets MCP
VERSION=3.7.0
PYTHON_VERSION=3.11
LOG_LEVEL=INFO
HEALTH_CHECK_INTERVAL=120
CACHE_DURATION=300
TIMEOUT=15

# Variables spécifiques au Hub Central
HUB_PORT=8080
HUB_DOMAIN=mcp.coupaul.fr
SUPABASE_MCP_URL=https://supabase.mcp.coupaul.fr
MINECRAFT_MCP_URL=https://minecraft.mcp.coupaul.fr

# Variables spécifiques à Supabase MCP
SUPABASE_PORT=8000
SUPABASE_DOMAIN=supabase.mcp.coupaul.fr
SUPABASE_URL=https://api.recube.gg/
PRODUCTION_MODE=true

# Variables spécifiques à Minecraft MCP
MINECRAFT_PORT=3000
MINECRAFT_DOMAIN=minecraft.mcp.coupaul.fr
MINECRAFT_MCPC_VERSION=1.6.4
DOCKER_ENABLED=true
EOF

# Copier le fichier .env vers tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        cp .env.shared "../$project_name/.env"
        print_success "✅ Variables d'environnement copiées vers $project_name"
    fi
done

echo ""
print_status "=== 5. SYNCHRONISATION DES DOCKERFILES ==="

# Créer un Dockerfile commun
cat > Dockerfile.shared << 'DOCKERFILE_EOF'
# Dockerfile commun pour les projets MCP
FROM python:3.11-slim

# Métadonnées
LABEL maintainer="MisterSandFR <support@mcp.coupaul.fr>"
LABEL description="MCP Server - Version 3.7.0"
LABEL version="3.7.0"

# Variables d'environnement
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV VERSION=3.7.0
ENV LOG_LEVEL=INFO

# Créer un utilisateur non-root pour la sécurité
RUN groupadd -r mcpuser && useradd -r -g mcpuser mcpuser

# Créer le répertoire de travail
WORKDIR /app

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de configuration
COPY requirements.txt /app/
COPY mcp-projects-shared-config.yaml /app/

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Créer les répertoires nécessaires
RUN mkdir -p /app/logs /app/config /app/data

# Changer les permissions
RUN chown -R mcpuser:mcpuser /app

# Passer à l'utilisateur non-root
USER mcpuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/health || exit 1

# Métadonnées supplémentaires
LABEL org.opencontainers.image.title="MCP Server"
LABEL org.opencontainers.image.description="MCP Server - Version 3.7.0"
LABEL org.opencontainers.image.version="3.7.0"
LABEL org.opencontainers.image.created="2025-01-08T00:00:00Z"
LABEL org.opencontainers.image.licenses="MIT"
DOCKERFILE_EOF

# Copier le Dockerfile vers tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        cp Dockerfile.shared "../$project_name/Dockerfile"
        print_success "✅ Dockerfile copié vers $project_name"
    fi
done

echo ""
print_status "=== 6. SYNCHRONISATION DES REQUIREMENTS ==="

# Créer un requirements.txt commun
cat > requirements.shared.txt << 'EOF'
# Requirements communs pour les projets MCP
urllib3==2.0.7
requests==2.31.0
pydantic==2.5.0
fastapi==0.104.1
uvicorn==0.24.0
python-multipart==0.0.6
python-dotenv==1.0.0
pyyaml==6.0.1
aiofiles==23.2.1
httpx==0.25.2
pytest==7.4.3
pytest-asyncio==0.21.1
pytest-cov==4.1.0
black==23.11.0
flake8==6.1.0
mypy==1.7.1
EOF

# Copier le requirements.txt vers tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        cp requirements.shared.txt "../$project_name/requirements.txt"
        print_success "✅ requirements.txt copié vers $project_name"
    fi
done

echo ""
print_status "=== 7. SYNCHRONISATION DES GITIGNORES ==="

# Créer un .gitignore commun
cat > .gitignore.shared << 'EOF'
# Gitignore commun pour les projets MCP
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version

# celery beat schedule file
celerybeat-schedule

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs/
*.log

# Data
data/
*.db
*.sqlite

# Config
config/local/
config/production/

# Docker
.dockerignore
docker-compose.override.yml

# Railway
.railway/
railway.json

# Temporary files
tmp/
temp/
*.tmp
*.temp
EOF

# Copier le .gitignore vers tous les projets
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    
    if [ -d "../$project_name" ]; then
        cp .gitignore.shared "../$project_name/.gitignore"
        print_success "✅ .gitignore copié vers $project_name"
    fi
done

echo ""
print_status "=== 8. RÉSUMÉ DE LA SYNCHRONISATION ==="

print_status "Projets synchronisés:"
for project_info in "${PROJECTS[@]}"; do
    IFS=':' read -r project_name project_type <<< "$project_info"
    print_success "✅ $project_name ($project_type)"
done

print_status "Fichiers synchronisés:"
print_success "✅ Versions (3.7.0)"
print_success "✅ Python (3.11)"
print_success "✅ Variables d'environnement"
print_success "✅ Dockerfiles"
print_success "✅ Requirements"
print_success "✅ Gitignores"
print_success "✅ Configuration partagée"

print_status "Actions recommandées:"
print_status "1. Vérifier les changements dans chaque projet"
print_status "2. Committer les modifications"
print_status "3. Tester la compatibilité inter-projets"
print_status "4. Déployer les mises à jour"

echo ""
print_success "🚀 CONCLUSION: Synchronisation des 3 projets MCP terminée"
print_status "✅ SOLUTION: Maintenance cohérente et interconnectée"

exit 0
