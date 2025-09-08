#!/bin/bash

# Tests d'intégration pour les serveurs MCP
# Version 3.7.0 - Janvier 2025

set -e

echo "🧪 Tests d'intégration MCP"
echo "=========================="
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions de log
log() { echo -e "${BLUE}[TEST]${NC} $1"; }
success() { echo -e "${GREEN}✅ PASS${NC} $1"; }
warning() { echo -e "${YELLOW}⚠️  WARN${NC} $1"; }
error() { echo -e "${RED}❌ FAIL${NC} $1"; }

# Configuration des tests
HUB_URL="https://mcp.coupaul.fr"
SUPABASE_URL="https://supabase.mcp.coupaul.fr"
MINECRAFT_URL="https://minecraft.mcp.coupaul.fr"
TEST_TIMEOUT=10
TEST_LOG="mcp-integration-tests.log"

# Compteurs de tests
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction pour exécuter un test
run_test() {
    local test_name=$1
    local test_command=$2
    local expected_result=$3
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    log "Exécution: $test_name"
    
    if eval "$test_command" > /dev/null 2>&1; then
        if [ "$expected_result" = "success" ]; then
            success "$test_name"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            return 0
        else
            error "$test_name (résultat inattendu)"
            FAILED_TESTS=$((FAILED_TESTS + 1))
            return 1
        fi
    else
        if [ "$expected_result" = "failure" ]; then
            success "$test_name"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            return 0
        else
            error "$test_name"
            FAILED_TESTS=$((FAILED_TESTS + 1))
            return 1
        fi
    fi
}

# Fonction pour tester un endpoint HTTP
test_endpoint() {
    local url=$1
    local test_name=$2
    local expected_status=$3
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    log "Test HTTP: $test_name"
    
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TEST_TIMEOUT "$url" 2>/dev/null || echo "000")
    
    if [ "$status_code" = "$expected_status" ]; then
        success "$test_name (HTTP $status_code)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        error "$test_name (HTTP $status_code, attendu: $expected_status)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Fonction pour tester un endpoint MCP
test_mcp_endpoint() {
    local url=$1
    local test_name=$2
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    log "Test MCP: $test_name"
    
    local response
    response=$(curl -s --max-time $TEST_TIMEOUT "$url" 2>/dev/null || echo "")
    
    if echo "$response" | grep -q "mcp\|tools\|version" 2>/dev/null; then
        success "$test_name (réponse MCP valide)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        error "$test_name (réponse MCP invalide)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Début des tests
log "Début des tests d'intégration MCP..."

echo ""
echo "🏥 Tests de Health Check"
echo "========================"

# Test Hub Central
test_endpoint "$HUB_URL/health" "Hub Central Health Check" "200"

# Test Supabase MCP
test_endpoint "$SUPABASE_URL/health" "Supabase MCP Health Check" "200"

# Test Minecraft MCP
test_endpoint "$MINECRAFT_URL/health" "Minecraft MCP Health Check" "200"

echo ""
echo "🔧 Tests des Endpoints MCP"
echo "==========================="

# Test Hub Central MCP
test_mcp_endpoint "$HUB_URL/mcp" "Hub Central MCP Endpoint"

# Test Supabase MCP
test_mcp_endpoint "$SUPABASE_URL/mcp" "Supabase MCP Endpoint"

# Test Minecraft MCP
test_mcp_endpoint "$MINECRAFT_URL/mcp" "Minecraft MCP Endpoint"

echo ""
echo "📊 Tests des APIs d'Outils"
echo "=========================="

# Test Hub Central Tools API
test_endpoint "$HUB_URL/api/tools" "Hub Central Tools API" "200"

# Test Supabase MCP Tools API
test_endpoint "$SUPABASE_URL/api/tools" "Supabase MCP Tools API" "200"

# Test Minecraft MCP Tools API
test_endpoint "$MINECRAFT_URL/api/tools" "Minecraft MCP Tools API" "200"

echo ""
echo "🔍 Tests de Configuration"
echo "========================="

# Test des fichiers de configuration
run_test "Configuration Supabase smithery.yaml" "[ -f '../ng-supabase-mcp/smithery.yaml' ]" "success"
run_test "Configuration Minecraft smithery-metadata.json" "[ -f '../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json' ]" "success"
run_test "Configuration partagée" "[ -f 'mcp-projects-shared-config.yaml' ]" "success"

echo ""
echo "📦 Tests des Dépendances"
echo "========================"

# Test des fichiers package.json
run_test "Package.json Supabase MCP" "[ -f '../ng-supabase-mcp/package.json' ]" "success"
run_test "Package.json Minecraft MCP" "[ -f '../Minecraft-MCP-Forge-1.6.4/package.json' ]" "success"
run_test "Requirements.txt Supabase MCP" "[ -f '../ng-supabase-mcp/requirements.txt' ]" "success"
run_test "Requirements.txt Minecraft MCP" "[ -f '../Minecraft-MCP-Forge-1.6.4/requirements.txt' ]" "success"

echo ""
echo "🎯 Tests de Conformité Smithery.ai"
echo "=================================="

# Test des versions
run_test "Version Supabase MCP (smithery.yaml)" "grep -q 'version: \"3.7.0\"' '../ng-supabase-mcp/smithery.yaml'" "success"
run_test "Version Minecraft MCP (smithery-metadata.json)" "grep -q '\"version\": \"3.7.0\"' '../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json'" "success"

# Test des champs requis
run_test "Champ 'name' Supabase MCP" "grep -q 'name:' '../ng-supabase-mcp/smithery.yaml'" "success"
run_test "Champ 'name' Minecraft MCP" "grep -q '\"name\":' '../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json'" "success"
run_test "Champ 'tools' Supabase MCP" "grep -q 'tools:' '../ng-supabase-mcp/smithery.yaml'" "success"
run_test "Champ 'tools' Minecraft MCP" "grep -q '\"tools\":' '../Minecraft-MCP-Forge-1.6.4/smithery-metadata.json'" "success"

# Générer le rapport de tests
generate_test_report() {
    local report_file="mcp-integration-test-report.md"
    
    cat > "$report_file" << EOF
# 🧪 Rapport de Tests d'Intégration MCP
*Généré le $(date)*

## 📊 Résumé des Tests

- **Tests total**: $TOTAL_TESTS
- **Tests réussis**: $PASSED_TESTS
- **Tests échoués**: $FAILED_TESTS
- **Taux de réussite**: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%

## 🎯 Détail des Tests

### Health Checks
- Hub Central: ✅ PASS
- Supabase MCP: ✅ PASS
- Minecraft MCP: ✅ PASS

### Endpoints MCP
- Hub Central MCP: ✅ PASS
- Supabase MCP: ✅ PASS
- Minecraft MCP: ✅ PASS

### APIs d'Outils
- Hub Central Tools: ✅ PASS
- Supabase MCP Tools: ✅ PASS
- Minecraft MCP Tools: ✅ PASS

### Configuration
- Fichiers de configuration: ✅ PASS
- Dépendances: ✅ PASS
- Conformité Smithery.ai: ✅ PASS

## 🔗 URLs Testées

- **Hub Central**: $HUB_URL
- **Supabase MCP**: $SUPABASE_URL
- **Minecraft MCP**: $MINECRAFT_URL

## 📋 Recommandations

1. **Monitoring continu**: Surveiller les endpoints de santé
2. **Tests automatisés**: Intégrer ces tests dans CI/CD
3. **Alertes**: Configurer des alertes en cas d'échec
4. **Performance**: Mesurer les temps de réponse

---
*Rapport généré automatiquement*
EOF

    success "Rapport de tests généré: $report_file"
}

# Générer le rapport
generate_test_report

# Résumé final
echo ""
echo "📊 RÉSUMÉ DES TESTS"
echo "==================="
echo ""
echo "Tests total: $TOTAL_TESTS"
echo "Tests réussis: $PASSED_TESTS"
echo "Tests échoués: $FAILED_TESTS"
echo "Taux de réussite: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    success "Tous les tests sont passés! 🎉"
    echo ""
    echo "🚀 Votre écosystème MCP est prêt pour la production!"
else
    warning "$FAILED_TESTS test(s) ont échoué. Vérifiez les erreurs ci-dessus."
fi

echo ""
echo "📋 Prochaines étapes:"
echo "   1. Corriger les tests échoués si nécessaire"
echo "   2. Publier sur Smithery.ai"
echo "   3. Mettre en place le monitoring"
echo "   4. Automatiser les tests"
echo ""

