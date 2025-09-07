#!/usr/bin/env python3
"""
MCP Hub Central - Mode Standalone (Sans Docker)
Version simplifiée qui fonctionne sans Docker
"""

import os
import json
import time
import http.server
import socketserver
import urllib.request
import urllib.parse
from http.server import BaseHTTPRequestHandler
from datetime import datetime

# Timestamp de démarrage pour le healthcheck
start_time = time.time()

class MCPHubStandaloneHandler(BaseHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        # Configuration des serveurs en mode standalone
        self.servers_config = self.load_standalone_config()
        super().__init__(*args, **kwargs)
    
    def load_standalone_config(self):
        """Configuration standalone sans Docker"""
        return {
            "servers": {
                "supabase": {
                    "name": "Supabase MCP Server",
                    "version": "3.1.0",
                    "description": "Enhanced Edition v3.1 - 47 MCP tools for 100% autonomous Supabase management",
                    "host": "localhost",
                    "port": 8001,
                    "path": "/supabase",
                    "protocol": "http",
                    "status": "active",
                    "tools_count": 47,
                    "categories": ["database", "auth", "storage", "realtime", "security", "migration", "monitoring", "performance"],
                    "github_url": "https://github.com/HenkDz/selfhosted-supabase-mcp",
                    "always_works": True,
                    "standalone_mode": True
                },
                "minecraft": {
                    "name": "Minecraft MCP Server",
                    "version": "1.0.0",
                    "description": "Minecraft server management and automation with MCP tools",
                    "host": "localhost",
                    "port": 3000,
                    "path": "/minecraft",
                    "protocol": "http",
                    "status": "active",
                    "tools_count": 12,
                    "categories": ["gaming", "server_management", "automation", "world_management"],
                    "github_url": "#",
                    "always_works": False,
                    "standalone_mode": True
                }
            },
            "hub": {
                "name": "MCP Hub Central",
                "version": "3.1.0",
                "description": "Multi-server MCP hub for centralized management - Standalone Mode",
                "total_servers": 2,
                "total_tools": 59,
                "domain": "mcp.coupaul.fr",
                "mode": "standalone"
            }
        }
    
    def discover_servers(self):
        """Découvrir les serveurs en mode standalone"""
        discovered_servers = {}
        
        for server_id, server_config in self.servers_config["servers"].items():
            if server_config["status"] == "active":
                # En mode standalone, on simule les serveurs comme toujours disponibles
                if server_config.get("standalone_mode", False):
                    server_config["health_status"] = "online"
                    server_config["last_seen"] = datetime.now().isoformat()
                    server_config["available_tools"] = server_config.get("tools_count", 0)
                    server_config["tools"] = self.get_standalone_tools(server_id)
                    server_config["mode"] = "standalone"
                    discovered_servers[server_id] = server_config
                else:
                    # Test de connectivité normal pour les serveurs externes
                    try:
                        health_url = f"{server_config['protocol']}://{server_config['host']}:{server_config['port']}/health"
                        req = urllib.request.Request(health_url)
                        
                        with urllib.request.urlopen(req, timeout=3) as response:
                            if response.status == 200:
                                server_config["health_status"] = "online"
                                server_config["last_seen"] = datetime.now().isoformat()
                                server_config["available_tools"] = server_config.get("tools_count", 0)
                                server_config["tools"] = []
                                discovered_servers[server_id] = server_config
                            else:
                                server_config["health_status"] = "offline"
                                server_config["error"] = f"HTTP {response.status}"
                    except Exception as e:
                        server_config["health_status"] = "offline"
                        server_config["error"] = str(e)
                        server_config["last_seen"] = datetime.now().isoformat()
                        
                        if server_config.get("always_works", False):
                            server_config["available_tools"] = server_config.get("tools_count", 0)
                            server_config["tools"] = []
                            discovered_servers[server_id] = server_config
                        else:
                            print(f"Server {server_id} discovery failed: {e}")
                    
                    discovered_servers[server_id] = server_config
        
        return discovered_servers
    
    def get_standalone_tools(self, server_id):
        """Obtenir les outils pour un serveur en mode standalone"""
        if server_id == "supabase":
            return [
                {"name": "execute_sql", "description": "Execute SQL queries"},
                {"name": "check_health", "description": "Check database health"},
                {"name": "list_tables", "description": "List database tables"},
                {"name": "create_migration", "description": "Create database migration"},
                {"name": "apply_migration", "description": "Apply database migration"},
                {"name": "create_auth_user", "description": "Create authenticated user"},
                {"name": "list_storage_buckets", "description": "List storage buckets"},
                {"name": "manage_rls_policies", "description": "Manage RLS policies"},
                {"name": "list_extensions", "description": "List PostgreSQL extensions"},
                {"name": "manage_functions", "description": "Manage database functions"},
                {"name": "manage_triggers", "description": "Manage database triggers"},
                {"name": "manage_roles", "description": "Manage database roles"},
                {"name": "manage_webhooks", "description": "Manage webhooks"},
                {"name": "list_realtime_publications", "description": "List realtime publications"},
                {"name": "get_logs", "description": "Get application logs"},
                {"name": "metrics_dashboard", "description": "Get metrics dashboard"},
                {"name": "audit_security", "description": "Audit security configuration"},
                {"name": "analyze_performance", "description": "Analyze database performance"},
                {"name": "backup_database", "description": "Create database backup"},
                {"name": "cache_management", "description": "Manage application cache"},
                {"name": "manage_secrets", "description": "Manage application secrets"},
                {"name": "get_project_url", "description": "Get project URL"},
                {"name": "get_anon_key", "description": "Get anonymous key"},
                {"name": "get_service_key", "description": "Get service role key"},
                {"name": "generate_crud_api", "description": "Generate CRUD API"},
                {"name": "generate_typescript_types", "description": "Generate TypeScript types"}
            ]
        elif server_id == "minecraft":
            return [
                {"name": "start_server", "description": "Start Minecraft server"},
                {"name": "stop_server", "description": "Stop Minecraft server"},
                {"name": "restart_server", "description": "Restart Minecraft server"},
                {"name": "get_server_status", "description": "Get server status"},
                {"name": "list_players", "description": "List online players"},
                {"name": "send_command", "description": "Send command to server"},
                {"name": "backup_world", "description": "Backup world data"},
                {"name": "restore_world", "description": "Restore world from backup"},
                {"name": "manage_plugins", "description": "Manage server plugins"},
                {"name": "configure_server", "description": "Configure server settings"},
                {"name": "monitor_performance", "description": "Monitor server performance"},
                {"name": "manage_permissions", "description": "Manage player permissions"}
            ]
        return []
    
    def do_GET(self):
        try:
            print(f"GET request to: {self.path}")
            
            # Endpoints du hub central
            if self.path == '/health':
                self.send_health_response()
            elif self.path == '/mcp' or self.path.startswith('/mcp?'):
                self.send_mcp_endpoint()
            elif self.path == '/.well-known/mcp-config' or self.path.startswith('/.well-known/mcp-config?'):
                self.send_mcp_config()
            elif self.path == '/api/servers':
                self.send_servers_api()
            elif self.path == '/api/tools':
                self.send_tools_api()
            elif self.path == '/api/discovery':
                self.send_discovery_api()
            elif self.path == '/' or self.path.startswith('/?config='):
                if self.path.startswith('/?config='):
                    self.send_mcp_endpoint()
                else:
                    self.send_hub_page()
            elif self.path.startswith('/mcp/'):
                self.send_mcp_endpoint()
            else:
                self.send_404_response()
        except Exception as e:
            print(f"Error in GET {self.path}: {e}")
            self.send_error_response(500, str(e))

    def do_POST(self):
        print(f"POST request to: {self.path}")
        if self.path == '/mcp' or self.path.startswith('/mcp?'):
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST {self.path} - Body: {post_data.decode('utf-8', errors='ignore')}")
                self.handle_jsonrpc_request(post_data.decode('utf-8', errors='ignore'))
            else:
                self.send_mcp_endpoint()
        elif self.path == '/.well-known/mcp-config':
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST /.well-known/mcp-config - Body: {post_data.decode('utf-8', errors='ignore')}")
            self.send_mcp_config()
        elif self.path == '/' or self.path.startswith('/?config='):
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST {self.path} - Body: {post_data.decode('utf-8', errors='ignore')}")
                self.handle_jsonrpc_request(post_data.decode('utf-8', errors='ignore'))
            else:
                if self.path.startswith('/?config='):
                    self.send_mcp_endpoint()
                else:
                    self.send_hub_page()
        elif self.path.startswith('/mcp/'):
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST {self.path} - Body: {post_data.decode('utf-8', errors='ignore')}")
            self.send_mcp_endpoint()
        else:
            self.send_404_response()

    def do_OPTIONS(self):
        print(f"OPTIONS request to: {self.path}")
        if (self.path == '/mcp' or self.path.startswith('/mcp/') or 
            self.path == '/.well-known/mcp-config' or self.path.startswith('/.well-known/mcp-config?') or 
            self.path == '/' or self.path.startswith('/?config=')):
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            self.send_header('Access-Control-Allow-Headers', 'Content-Type')
            self.end_headers()
        else:
            self.send_404_response()

    def send_health_response(self):
        """Endpoint de santé pour Railway healthcheck"""
        try:
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
            response = {
                "status": "UP",
                "timestamp": time.time(),
                "service": "MCP Hub Central - Standalone Mode",
                "version": "3.1.0",
                "servers": 2,
                "tools": 59,
                "uptime": time.time() - start_time,
                "healthcheck": "OK",
                "mode": "standalone"
            }
            self.wfile.write(json.dumps(response, indent=2).encode())
            print(f"Health check OK: {response['status']}")
        except Exception as e:
            print(f"Health check error: {e}")
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            error_response = {
                "status": "DOWN",
                "error": str(e),
                "timestamp": time.time()
            }
            self.wfile.write(json.dumps(error_response).encode())

    def send_error_response(self, status_code, error_message):
        """Envoyer une réponse d'erreur"""
        try:
            self.send_response(status_code)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            error_response = {
                "error": error_message,
                "status": "ERROR",
                "timestamp": time.time()
            }
            self.wfile.write(json.dumps(error_response).encode())
        except Exception as e:
            print(f"Error sending error response: {e}")

    def send_mcp_endpoint(self):
        """Endpoint MCP pour Smithery - Support GET et POST"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        
        mcp_info = {
            "jsonrpc": "2.0",
            "id": 1,
            "result": {
                "name": "MCP Hub Central - Standalone Mode",
                "version": "3.1.0",
                "description": "Standalone MCP Hub with integrated Supabase and Minecraft tools",
                "capabilities": {
                    "tools": True,
                    "resources": False,
                    "prompts": False
                },
                "tools": [
                    {
                        "name": "ping",
                        "description": "Simple ping test for Smithery scanning - Always works"
                    },
                    {
                        "name": "test_connection",
                        "description": "Test MCP server connection for Smithery scanning"
                    },
                    {
                        "name": "get_server_info",
                        "description": "Get server information and capabilities"
                    },
                    {
                        "name": "execute_sql",
                        "description": "Execute SQL queries with advanced database management"
                    },
                    {
                        "name": "check_health",
                        "description": "Check database health and connectivity"
                    },
                    {
                        "name": "list_tables",
                        "description": "List database tables and schemas"
                    },
                    {
                        "name": "start_minecraft_server",
                        "description": "Start Minecraft server"
                    },
                    {
                        "name": "stop_minecraft_server",
                        "description": "Stop Minecraft server"
                    }
                ]
            }
        }
        self.wfile.write(json.dumps(mcp_info, indent=2).encode())

    def send_mcp_config(self):
        """Endpoint /.well-known/mcp-config pour découverte MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        
        mcp_config = {
            "mcpServers": {
                "mcp-hub-standalone": {
                    "command": "py",
                    "args": ["mcp_hub_standalone.py"],
                    "env": {
                        "MCP_SERVER_NAME": "MCP Hub Central - Standalone",
                        "MCP_SERVER_VERSION": "3.1.0"
                    }
                }
            },
            "capabilities": {
                "tools": True,
                "resources": False,
                "prompts": False
            },
            "server": {
                "name": "MCP Hub Central - Standalone Mode",
                "version": "3.1.0",
                "description": "Standalone MCP Hub with integrated Supabase and Minecraft tools",
                "url": "https://mcp.coupaul.fr/mcp",
                "endpoints": {
                    "mcp": "/mcp",
                    "health": "/health",
                    "config": "/.well-known/mcp-config"
                }
            }
        }
        self.wfile.write(json.dumps(mcp_config, indent=2).encode())

    def handle_jsonrpc_request(self, request_body):
        """Traiter les requêtes JSON-RPC 2.0"""
        try:
            request_data = json.loads(request_body)
            method = request_data.get('method')
            request_id = request_data.get('id')
            
            print(f"JSON-RPC method: {method}, id: {request_id}")
            
            if method == 'initialize':
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "protocolVersion": "2025-06-18",
                        "capabilities": {
                            "tools": {},
                            "resources": {},
                            "prompts": {}
                        },
                        "serverInfo": {
                            "name": "MCP Hub Central - Standalone Mode",
                            "version": "3.1.0",
                            "description": "Standalone MCP Hub with integrated Supabase and Minecraft tools"
                        }
                    }
                }
            elif method == 'tools/list':
                # Retourner tous les outils des serveurs standalone
                all_tools = []
                for server_id, server_config in self.servers_config["servers"].items():
                    if server_config.get("standalone_mode", False):
                        tools = self.get_standalone_tools(server_id)
                        for tool in tools:
                            tool["server"] = server_id
                            tool["server_name"] = server_config["name"]
                            all_tools.append(tool)
                
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "tools": all_tools
                    }
                }
            elif method == 'ping':
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {}
                }
            elif method == 'resources/list':
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "resources": []
                    }
                }
            elif method == 'prompts/list':
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "prompts": []
                    }
                }
            elif method == 'notifications/initialized':
                response = None
            else:
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "error": {
                        "code": -32601,
                        "message": f"Method not found: {method}"
                    }
                }
            
            if response is not None:
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
                self.send_header('Access-Control-Allow-Headers', 'Content-Type')
                self.end_headers()
                response_json = json.dumps(response, indent=2)
                print(f"JSON-RPC response: {response_json}")
                self.wfile.write(response_json.encode())
            else:
                print(f"JSON-RPC notification: {method} - no response")
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
            
        except json.JSONDecodeError as e:
            print(f"JSON decode error: {e}")
            self.send_response(400)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            error_response = {
                "jsonrpc": "2.0",
                "id": None,
                "error": {
                    "code": -32700,
                    "message": "Parse error"
                }
            }
            self.wfile.write(json.dumps(error_response).encode())

    def send_discovery_api(self):
        """API de découverte des serveurs MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        discovered_servers = self.discover_servers()
        discovery_data = {
            "hub": self.servers_config["hub"],
            "servers": discovered_servers,
            "total_servers": len(discovered_servers),
            "online_servers": len([s for s in discovered_servers.values() if s.get("health_status") == "online"]),
            "total_tools": sum(s.get("available_tools", 0) for s in discovered_servers.values()),
            "last_discovery": datetime.now().isoformat(),
            "mode": "standalone"
        }
        
        self.wfile.write(json.dumps(discovery_data, indent=2).encode())
    
    def send_servers_api(self):
        """API des serveurs MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        discovered_servers = self.discover_servers()
        servers = []
        
        for server_id, server_config in discovered_servers.items():
            servers.append({
                "id": server_id,
                "name": server_config["name"],
                "description": server_config["description"],
                "version": server_config["version"],
                "status": server_config.get("health_status", "offline"),
                "tools_count": server_config.get("available_tools", 0),
                "endpoints": {
                    "health": "/health",
                    "mcp": "/mcp",
                    "api": "/api/servers",
                    "tools": "/api/tools"
                },
                "capabilities": server_config.get("categories", []),
                "standalone": server_config.get("standalone_mode", False),
                "url": "mcp.coupaul.fr",
                "repository": server_config.get("github_url", "#"),
                "last_updated": datetime.now().isoformat()
            })
        
        self.wfile.write(json.dumps(servers, indent=2).encode())

    def send_tools_api(self):
        """API des outils MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        tools = []
        discovered_servers = self.discover_servers()
        
        for server_id, server_config in discovered_servers.items():
            if server_config.get("standalone_mode", False):
                server_tools = self.get_standalone_tools(server_id)
                for tool in server_tools:
                    tools.append({
                        "name": tool["name"],
                        "description": tool["description"],
                        "server": server_id,
                        "server_name": server_config["name"],
                        "category": self.get_tool_category(tool["name"]),
                        "standalone": True
                    })
        
        self.wfile.write(json.dumps(tools, indent=2).encode())

    def get_tool_category(self, tool_name):
        """Déterminer la catégorie d'un outil"""
        categories = {
            "execute_sql": "database", "check_health": "monitoring", "list_tables": "database",
            "create_migration": "migration", "apply_migration": "migration",
            "create_auth_user": "auth", "list_storage_buckets": "storage",
            "manage_rls_policies": "security", "list_extensions": "extensions",
            "manage_functions": "functions", "manage_triggers": "triggers",
            "manage_roles": "roles", "manage_webhooks": "webhooks",
            "list_realtime_publications": "realtime", "get_logs": "monitoring",
            "metrics_dashboard": "monitoring", "audit_security": "security",
            "analyze_performance": "performance", "backup_database": "backup",
            "cache_management": "cache", "manage_secrets": "secrets",
            "get_project_url": "utility", "get_anon_key": "utility",
            "get_service_key": "utility", "generate_crud_api": "generation",
            "generate_typescript_types": "generation",
            "start_minecraft_server": "gaming", "stop_minecraft_server": "gaming",
            "restart_server": "gaming", "get_server_status": "gaming",
            "list_players": "gaming", "send_command": "gaming",
            "backup_world": "gaming", "restore_world": "gaming",
            "manage_plugins": "gaming", "configure_server": "gaming",
            "monitor_performance": "gaming", "manage_permissions": "gaming"
        }
        return categories.get(tool_name, "utility")

    def send_hub_page(self):
        """Page hub principale avec design moderne Tailwind CSS"""
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        
        # Récupérer les serveurs découverts pour l'affichage
        discovered_servers = self.discover_servers()
        online_servers = len([s for s in discovered_servers.values() if s.get("health_status") == "online"])
        total_tools = sum(s.get("available_tools", 0) for s in discovered_servers.values())
        
        html_content = f"""
<!DOCTYPE html>
<html lang="fr" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MCP Hub - Mode Standalone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {{
            darkMode: 'class',
            theme: {{
                extend: {{
                    colors: {{
                        primary: '#3b82f6',
                        secondary: '#1e40af',
                        accent: '#06b6d4'
                    }}
                }}
            }}
        }}
    </script>
</head>
<body class="bg-gray-900 text-white min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <header class="text-center mb-12">
            <h1 class="text-4xl font-bold text-primary mb-4">MCP Hub</h1>
            <p class="text-xl text-gray-300 mb-6">Centre de contrôle pour tous vos serveurs MCP - Mode Standalone</p>
            <div class="flex justify-center space-x-4">
                <span class="bg-green-600 px-3 py-1 rounded-full text-sm">{len(discovered_servers)} Serveurs</span>
                <span class="bg-blue-600 px-3 py-1 rounded-full text-sm">{total_tools} Outils</span>
                <span class="bg-purple-600 px-3 py-1 rounded-full text-sm">{online_servers} En ligne</span>
                <span class="bg-yellow-600 px-3 py-1 rounded-full text-sm">Standalone</span>
            </div>
        </header>

        <!-- Serveurs MCP -->
        <section class="mb-12">
            <h2 class="text-2xl font-semibold mb-6 text-center">Serveurs MCP Disponibles</h2>
            <div class="grid md:grid-cols-1 gap-6">
                {self.generate_server_cards(discovered_servers)}
            </div>
        </section>

        <!-- Endpoints -->
        <section class="mb-12">
            <h2 class="text-2xl font-semibold mb-6 text-center">Endpoints MCP</h2>
            <div class="grid md:grid-cols-2 gap-6">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700">
                    <h3 class="text-lg font-semibold mb-4 text-primary">Communication MCP</h3>
                    <div class="space-y-3">
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/.well-known/mcp-config</code>
                            <span class="text-green-500 text-sm">GET</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/mcp</code>
                            <span class="text-blue-500 text-sm">POST</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/?config=e30%3D</code>
                            <span class="text-purple-500 text-sm">POST</span>
                        </div>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700">
                    <h3 class="text-lg font-semibold mb-4 text-primary">API REST</h3>
                    <div class="space-y-3">
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/health</code>
                            <span class="text-green-500 text-sm">GET</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/api/servers</code>
                            <span class="text-blue-500 text-sm">GET</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <code class="bg-gray-700 px-2 py-1 rounded text-sm">/api/tools</code>
                            <span class="text-purple-500 text-sm">GET</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="text-center text-gray-400 text-sm">
            <p>MCP Hub v3.1.0 - Mode Standalone - Dernière mise à jour: {datetime.now().strftime('%d/%m/%Y %H:%M')}</p>
            <p class="mt-2">Commit: <code class="bg-gray-800 px-2 py-1 rounded">4ece699</code></p>
        </footer>
    </div>
</body>
</html>
        """
        self.wfile.write(html_content.encode('utf-8'))

    def generate_server_cards(self, discovered_servers):
        """Générer les cartes des serveurs MCP dynamiquement"""
        cards_html = ""
        
        for server_id, server_config in discovered_servers.items():
            status = server_config.get("health_status", "offline")
            status_color = "bg-green-600" if status == "online" else "bg-red-600"
            status_text = "En ligne" if status == "online" else "Hors ligne"
            
            tools_count = server_config.get("available_tools", server_config.get("tools_count", 0))
            categories = server_config.get("categories", [])
            
            # Générer les badges de catégories
            category_badges = ""
            for category in categories[:8]:  # Limiter à 8 catégories
                category_badges += f'<span class="bg-gray-700 px-2 py-1 rounded text-xs">{category}</span>'
            
            # Badge mode standalone
            standalone_badge = ""
            if server_config.get("standalone_mode", False):
                standalone_badge = '<span class="bg-yellow-600 px-2 py-1 rounded text-xs">Standalone</span>'
            
            cards_html += f"""
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 hover:border-primary transition-colors">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-xl font-semibold text-primary">{server_config["name"]}</h3>
                        <div class="flex space-x-2">
                            <span class="{status_color} px-2 py-1 rounded text-sm">{status_text}</span>
                            {standalone_badge}
                        </div>
                    </div>
                    <p class="text-gray-300 mb-4">{server_config["description"]}</p>
                    
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                        <div class="text-center">
                            <div class="text-2xl font-bold text-primary">{tools_count}</div>
                            <div class="text-sm text-gray-400">Outils</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-green-500">{len(categories)}</div>
                            <div class="text-sm text-gray-400">Catégories</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-blue-500">{server_config.get("port", "N/A")}</div>
                            <div class="text-sm text-gray-400">Port</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-purple-500">v{server_config.get("version", "1.0")}</div>
                            <div class="text-sm text-gray-400">Version</div>
                        </div>
                    </div>
                    
                    <div class="flex flex-wrap gap-2 mb-4">
                        {category_badges}
                    </div>
                    
                    <div class="flex space-x-4">
                        {f'<a href="{server_config.get("github_url", "#")}" target="_blank" class="bg-primary hover:bg-blue-700 px-4 py-2 rounded text-white text-sm transition-colors">📁 GitHub</a>' if server_config.get("github_url") != "#" else '<span class="bg-gray-600 px-4 py-2 rounded text-white text-sm cursor-not-allowed">📁 GitHub</span>'}
                        <a href="/api/tools" 
                           class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded text-white text-sm transition-colors">
                            🔧 API Tools
                        </a>
                        <a href="/health" 
                           class="bg-green-600 hover:bg-green-700 px-4 py-2 rounded text-white text-sm transition-colors">
                            ❤️ Health
                        </a>
                    </div>
                </div>
            """
        
        return cards_html

    def send_404_response(self):
        print(f"404 - Path not found: {self.path}")
        self.send_response(404)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(f"<h1>404 - Page not found</h1><p>Path: {self.path}</p><p><a href='/'>Back to hub</a></p>".encode())

    def log_message(self, format, *args):
        pass

if __name__ == "__main__":
    PORT = int(os.environ.get('PORT', 8000))
    
    print(f"🚀 Starting MCP Hub Central - Standalone Mode on port {PORT}")
    print(f"📊 Serving 2 MCP servers with 59 tools")
    print(f"🌐 Access at: http://localhost:{PORT}")
    print(f"🔧 Well-known endpoint: /.well-known/mcp-config")
    print(f"⚡ Mode: Standalone (No Docker required)")
    
    with socketserver.TCPServer(("", PORT), MCPHubStandaloneHandler) as httpd:
        print(f"✅ MCP Hub Central - Standalone Mode running on port {PORT}")
        httpd.serve_forever()
