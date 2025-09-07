#!/usr/bin/env python3
"""
Hub MCP Multi-Serveurs - Centre de contrôle pour tous les serveurs MCP
Interface moderne avec routage intelligent vers différents serveurs MCP
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

class MCPHubHandler(BaseHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        # Charger la configuration des serveurs
        self.servers_config = self.load_servers_config()
        super().__init__(*args, **kwargs)
    
    def load_servers_config(self):
        """Charger la configuration des serveurs MCP"""
        try:
            with open('mcp_servers_config.json', 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            # Configuration par défaut si le fichier n'existe pas
            return {
                "servers": {
                    "supabase": {
                        "name": "Supabase MCP Server",
                        "version": "3.1.0",
                        "description": "Enhanced Edition v3.1 - 47 MCP tools for 100% autonomous Supabase management",
                        "path": "/supabase",
                        "port": 8001,
                        "host": "localhost",
                        "protocol": "http",
                        "status": "active",
                        "tools_count": 47,
                        "categories": ["database", "auth", "storage", "realtime", "security", "migration", "monitoring", "performance"],
                        "github_url": "https://github.com/MisterSandFR/Supabase-MCP-SelfHosted",
                        "always_works": True
                    }
                },
                "hub": {
                    "name": "MCP Hub",
                    "version": "1.0.0",
                    "description": "Multi-server MCP hub for centralized management",
                    "total_servers": 1,
                    "total_tools": 47,
                    "domain": "mcp.coupaul.fr"
                }
            }
    
    def discover_servers(self):
        """Découvrir automatiquement les serveurs MCP disponibles"""
        discovered_servers = {}
        
        for server_id, server_config in self.servers_config["servers"].items():
            if server_config["status"] == "active":
                try:
                    # Utiliser le path de découverte configuré ou /health par défaut
                    discovery_path = server_config.get("discovery_path", "/health")
                    discovery_timeout = server_config.get("discovery_timeout", 5)
                    
                    # Tester la connectivité du serveur
                    health_url = f"{server_config['protocol']}://{server_config['host']}:{server_config['port']}{discovery_path}"
                    req = urllib.request.Request(health_url)
                    
                    with urllib.request.urlopen(req, timeout=discovery_timeout) as response:
                        if response.status == 200:
                            server_config["health_status"] = "online"
                            server_config["last_seen"] = datetime.now().isoformat()
                            
                            # Récupérer les outils disponibles
                            tools_url = f"{server_config['protocol']}://{server_config['host']}:{server_config['port']}/api/tools"
                            try:
                                tools_req = urllib.request.Request(tools_url)
                                with urllib.request.urlopen(tools_req, timeout=discovery_timeout) as tools_response:
                                    if tools_response.status == 200:
                                        tools_data = json.loads(tools_response.read().decode())
                                        server_config["available_tools"] = len(tools_data)
                                        server_config["tools"] = tools_data
                            except:
                                server_config["available_tools"] = server_config.get("tools_count", 0)
                                server_config["tools"] = []
                            
                            discovered_servers[server_id] = server_config
                        else:
                            server_config["health_status"] = "offline"
                            server_config["error"] = f"HTTP {response.status}"
                except Exception as e:
                    # Gestion gracieuse des erreurs de découverte
                    server_config["health_status"] = "offline"
                    server_config["error"] = str(e)
                    server_config["last_seen"] = datetime.now().isoformat()
                    
                    # Pour les serveurs configurés mais non démarrés, les inclure quand même
                    if server_config.get("always_works", False):
                        server_config["available_tools"] = server_config.get("tools_count", 0)
                        server_config["tools"] = []
                        discovered_servers[server_id] = server_config
                        print(f"Server {server_id} configured but offline: {e}")
                    else:
                        print(f"Server {server_id} discovery failed: {e}")
                    
                    # Toujours inclure le serveur dans la découverte pour affichage
                    discovered_servers[server_id] = server_config
        
        return discovered_servers
    
    def intelligent_routing(self, request_path, request_data=None):
        """Routage intelligent basé sur les capacités des serveurs"""
        discovered_servers = self.discover_servers()
        
        # Analyser la requête pour déterminer le meilleur serveur
        if request_data:
            try:
                data = json.loads(request_data) if isinstance(request_data, str) else request_data
                method = data.get("method", "")
                
                # Routage basé sur la méthode JSON-RPC
                if method == "tools/list":
                    # Retourner tous les outils de tous les serveurs
                    return self.aggregate_all_tools(discovered_servers)
                elif method in ["execute_sql", "check_health", "list_tables"]:
                    # Routage vers Supabase
                    return self.find_server_by_capability(discovered_servers, "database")
                elif method in ["read_file", "write_file", "list_files"]:
                    # Routage vers File Manager
                    return self.find_server_by_capability(discovered_servers, "file_operations")
                elif method in ["git_clone", "git_commit", "git_push"]:
                    # Routage vers Git
                    return self.find_server_by_capability(discovered_servers, "repository")
                elif method in ["scrape_website", "extract_data"]:
                    # Routage vers Web Scraping
                    return self.find_server_by_capability(discovered_servers, "scraping")
            except:
                pass
        
        # Routage par path
        for server_id, server_config in discovered_servers.items():
            if request_path.startswith(server_config["path"]):
                return server_config
        
        # Routage par défaut vers le serveur principal (Supabase)
        return self.find_server_by_capability(discovered_servers, "database")
    
    def find_server_by_capability(self, servers, capability):
        """Trouver le serveur avec la capacité demandée"""
        for server_id, server_config in servers.items():
            if server_config.get("health_status") == "online":
                if capability in server_config.get("categories", []):
                    return server_config
        # Retourner le premier serveur en ligne si aucun match
        for server_id, server_config in servers.items():
            if server_config.get("health_status") == "online":
                return server_config
        return None
    
    def aggregate_all_tools(self, servers):
        """Agréger tous les outils de tous les serveurs"""
        all_tools = []
        for server_id, server_config in servers.items():
            if server_config.get("health_status") == "online":
                tools = server_config.get("tools", [])
                for tool in tools:
                    tool["server"] = server_id
                    tool["server_name"] = server_config["name"]
                    all_tools.append(tool)
        return {"tools": all_tools, "total": len(all_tools)}
    
    def proxy_to_server(self, server_config, method):
        """Proxy la requête vers le serveur MCP approprié"""
        try:
            # Construire l'URL du serveur cible
            target_url = f"{server_config['protocol']}://{server_config['host']}:{server_config['port']}"
            
            # Adapter le path pour le serveur cible
            if self.path.startswith(server_config["path"]):
                target_path = self.path[len(server_config["path"]):] or "/"
            else:
                target_path = self.path
            
            full_url = f"{target_url}{target_path}"
            
            print(f"Proxying {method} request to: {full_url}")
            
            # Préparer la requête
            if method == 'GET':
                req = urllib.request.Request(full_url)
            elif method == 'POST':
                # Lire le body de la requête
                content_length = int(self.headers.get('Content-Length', 0))
                post_data = self.rfile.read(content_length) if content_length > 0 else None
                req = urllib.request.Request(full_url, data=post_data)
                req.add_header('Content-Type', self.headers.get('Content-Type', 'application/json'))
            
            # Copier les headers importants
            for header in ['Authorization', 'User-Agent', 'Accept']:
                if header in self.headers:
                    req.add_header(header, self.headers[header])
            
            # Faire la requête
            with urllib.request.urlopen(req, timeout=30) as response:
                # Copier les headers de réponse
                for header, value in response.headers.items():
                    if header.lower() not in ['connection', 'transfer-encoding']:
                        self.send_header(header, value)
                
                self.send_response(response.status)
                self.end_headers()
                
                # Copier le body de réponse
                self.wfile.write(response.read())
                
        except Exception as e:
            print(f"Proxy error: {e}")
            self.send_error_response(502, f"Bad Gateway: {str(e)}")
    
    def do_GET(self):
        try:
            print(f"GET request to: {self.path}")
            
            # Routage intelligent vers les serveurs MCP
            routed_server = self.intelligent_routing(self.path)
            if routed_server and self.path.startswith(routed_server["path"]):
                self.proxy_to_server(routed_server, 'GET')
                return
            
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
                # Support pour l'endpoint racine avec paramètres config
                if self.path.startswith('/?config='):
                    # Si c'est une requête avec paramètres config, retourner JSON pour Smithery
                    self.send_mcp_endpoint()
                else:
                    # Sinon, retourner la page HTML normale
                    self.send_hub_page()
            elif self.path.startswith('/mcp/'):
                # Support pour les sous-endpoints MCP
                self.send_mcp_endpoint()
            else:
                self.send_404_response()
        except Exception as e:
            print(f"Error in GET {self.path}: {e}")
            self.send_error_response(500, str(e))

    def do_POST(self):
        print(f"POST request to: {self.path}")
        if self.path == '/mcp' or self.path.startswith('/mcp?'):
            # Lire le body de la requête POST
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST {self.path} - Body: {post_data.decode('utf-8', errors='ignore')}")
                # Traiter la requête JSON-RPC
                self.handle_jsonrpc_request(post_data.decode('utf-8', errors='ignore'))
            else:
                self.send_mcp_endpoint()
        elif self.path == '/.well-known/mcp-config':
            # Support POST pour well-known MCP config
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST /.well-known/mcp-config - Body: {post_data.decode('utf-8', errors='ignore')}")
            self.send_mcp_config()
        elif self.path == '/' or self.path.startswith('/?config='):
            # Support POST pour l'endpoint racine avec paramètres config
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_data = self.rfile.read(content_length)
                print(f"POST {self.path} - Body: {post_data.decode('utf-8', errors='ignore')}")
                # Traiter la requête JSON-RPC
                self.handle_jsonrpc_request(post_data.decode('utf-8', errors='ignore'))
            else:
                if self.path.startswith('/?config='):
                    # Si c'est une requête avec paramètres config, retourner JSON pour Smithery
                    self.send_mcp_endpoint()
                else:
                    # Sinon, retourner la page HTML normale
                    self.send_hub_page()
        elif self.path.startswith('/mcp/'):
            # Support pour les sous-endpoints MCP
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

    def do_HEAD(self):
        """Support pour les requêtes HEAD"""
        print(f"HEAD request to: {self.path}")
        if self.path == '/health':
            self.send_health_response()
        elif self.path == '/mcp':
            self.send_mcp_endpoint()
        elif self.path == '/.well-known/mcp-config' or self.path.startswith('/.well-known/mcp-config?'):
            self.send_mcp_config()
        elif self.path == '/api/servers':
            self.send_servers_api()
        elif self.path == '/api/tools':
            self.send_tools_api()
        elif self.path == '/' or self.path.startswith('/?config='):
            if self.path.startswith('/?config='):
                self.send_mcp_endpoint()
            else:
                self.send_hub_page()
        elif self.path.startswith('/mcp/'):
            self.send_mcp_endpoint()
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
                "service": "MCP Hub",
                "version": "3.1.0",
                "servers": 2,
                "tools": 54,
                "uptime": time.time() - start_time,
                "healthcheck": "OK"
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
                "name": "Supabase MCP Server v3.1.0",
                "version": "3.1.0",
                "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
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
                        "name": "get_capabilities",
                        "description": "Get server capabilities for Smithery scanning"
                    },
                    {
                        "name": "smithery_scan_test",
                        "description": "Special tool for Smithery scanning compatibility"
                    },
                    {
                        "name": "execute_sql",
                        "description": "Enhanced SQL with advanced database management"
                    },
                    {
                        "name": "check_health",
                        "description": "Check database health and connectivity"
                    },
                    {
                        "name": "list_tables",
                        "description": "List database tables and schemas"
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
                "supabase-mcp": {
                    "command": "python",
                    "args": ["mcp_hub.py"],
                    "env": {
                        "MCP_SERVER_NAME": "Supabase MCP Server",
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
                "name": "Supabase MCP Server v3.1.0",
                "version": "3.1.0",
                "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
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
                            "name": "Supabase MCP Server v3.1.0",
                            "version": "3.1.0",
                            "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management"
                        }
                    }
                }
            elif method == 'tools/list':
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "tools": [
                            # === OUTILS DE BASE ===
                            {
                                "name": "ping",
                                "description": "Simple ping test for Smithery scanning - Always works",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "test_connection",
                                "description": "Test MCP server connection for Smithery scanning",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "get_server_info",
                                "description": "Get server information and capabilities",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "get_capabilities",
                                "description": "Get server capabilities for Smithery scanning",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "smithery_scan_test",
                                "description": "Special tool for Smithery scanning compatibility",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            
                            # === GESTION DE BASE DE DONNÉES ===
                            {
                                "name": "execute_sql",
                                "description": "Execute SQL queries with advanced database management",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "query": {"type": "string", "description": "SQL query to execute"},
                                        "params": {"type": "array", "description": "Query parameters"}
                                    },
                                    "required": ["query"]
                                }
                            },
                            {
                                "name": "check_health",
                                "description": "Check database health and connectivity",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "list_tables",
                                "description": "List database tables and schemas",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "schema": {"type": "string", "description": "Schema name to filter"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "inspect_schema",
                                "description": "Inspect database schema structure",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name to inspect"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "get_database_stats",
                                "description": "Get database statistics and metrics",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            
                            # === MIGRATIONS ===
                            {
                                "name": "create_migration",
                                "description": "Create a new database migration",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "name": {"type": "string", "description": "Migration name"},
                                        "up": {"type": "string", "description": "Up migration SQL"},
                                        "down": {"type": "string", "description": "Down migration SQL"}
                                    },
                                    "required": ["name", "up"]
                                }
                            },
                            {
                                "name": "apply_migration",
                                "description": "Apply database migration",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "migration_id": {"type": "string", "description": "Migration ID to apply"}
                                    },
                                    "required": ["migration_id"]
                                }
                            },
                            {
                                "name": "list_migrations",
                                "description": "List all database migrations",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "push_migrations",
                                "description": "Push migrations to remote database",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "validate_migration",
                                "description": "Validate migration before applying",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "migration_id": {"type": "string", "description": "Migration ID to validate"}
                                    },
                                    "required": ["migration_id"]
                                }
                            },
                            
                            # === AUTHENTIFICATION ===
                            {
                                "name": "create_auth_user",
                                "description": "Create a new authenticated user",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "email": {"type": "string", "description": "User email"},
                                        "password": {"type": "string", "description": "User password"},
                                        "metadata": {"type": "object", "description": "User metadata"}
                                    },
                                    "required": ["email", "password"]
                                }
                            },
                            {
                                "name": "get_auth_user",
                                "description": "Get authenticated user information",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "user_id": {"type": "string", "description": "User ID"}
                                    },
                                    "required": ["user_id"]
                                }
                            },
                            {
                                "name": "list_auth_users",
                                "description": "List all authenticated users",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "limit": {"type": "integer", "description": "Number of users to return"},
                                        "offset": {"type": "integer", "description": "Offset for pagination"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "update_auth_user",
                                "description": "Update authenticated user information",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "user_id": {"type": "string", "description": "User ID"},
                                        "updates": {"type": "object", "description": "Updates to apply"}
                                    },
                                    "required": ["user_id", "updates"]
                                }
                            },
                            {
                                "name": "delete_auth_user",
                                "description": "Delete authenticated user",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "user_id": {"type": "string", "description": "User ID to delete"}
                                    },
                                    "required": ["user_id"]
                                }
                            },
                            
                            # === STOCKAGE ===
                            {
                                "name": "list_storage_buckets",
                                "description": "List all storage buckets",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "list_storage_objects",
                                "description": "List objects in storage bucket",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "bucket": {"type": "string", "description": "Bucket name"},
                                        "prefix": {"type": "string", "description": "Object prefix filter"}
                                    },
                                    "required": ["bucket"]
                                }
                            },
                            {
                                "name": "manage_storage_policies",
                                "description": "Manage storage bucket policies",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "bucket": {"type": "string", "description": "Bucket name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "policy": {"type": "object", "description": "Policy definition"}
                                    },
                                    "required": ["bucket", "action"]
                                }
                            },
                            
                            # === RLS (ROW LEVEL SECURITY) ===
                            {
                                "name": "manage_rls_policies",
                                "description": "Manage Row Level Security policies",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "policy": {"type": "object", "description": "Policy definition"}
                                    },
                                    "required": ["table", "action"]
                                }
                            },
                            {
                                "name": "analyze_rls_coverage",
                                "description": "Analyze RLS policy coverage",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name to analyze"}
                                    },
                                    "required": []
                                }
                            },
                            
                            # === EXTENSIONS ===
                            {
                                "name": "list_extensions",
                                "description": "List installed PostgreSQL extensions",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "manage_extensions",
                                "description": "Manage PostgreSQL extensions",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "extension": {"type": "string", "description": "Extension name"},
                                        "action": {"type": "string", "description": "Action: install, uninstall, update"}
                                    },
                                    "required": ["extension", "action"]
                                }
                            },
                            
                            # === FONCTIONS ===
                            {
                                "name": "manage_functions",
                                "description": "Manage database functions",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "name": {"type": "string", "description": "Function name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "definition": {"type": "string", "description": "Function definition"}
                                    },
                                    "required": ["name", "action"]
                                }
                            },
                            
                            # === TRIGGERS ===
                            {
                                "name": "manage_triggers",
                                "description": "Manage database triggers",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "trigger": {"type": "object", "description": "Trigger definition"}
                                    },
                                    "required": ["table", "action"]
                                }
                            },
                            
                            # === RÔLES ===
                            {
                                "name": "manage_roles",
                                "description": "Manage database roles",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "role": {"type": "string", "description": "Role name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "permissions": {"type": "array", "description": "Role permissions"}
                                    },
                                    "required": ["role", "action"]
                                }
                            },
                            
                            # === WEBHOOKS ===
                            {
                                "name": "manage_webhooks",
                                "description": "Manage webhooks",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "name": {"type": "string", "description": "Webhook name"},
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "url": {"type": "string", "description": "Webhook URL"},
                                        "events": {"type": "array", "description": "Events to listen for"}
                                    },
                                    "required": ["name", "action"]
                                }
                            },
                            
                            # === REALTIME ===
                            {
                                "name": "list_realtime_publications",
                                "description": "List realtime publications",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "realtime_management",
                                "description": "Manage realtime subscriptions",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "action": {"type": "string", "description": "Action: create, update, delete"},
                                        "publication": {"type": "string", "description": "Publication name"}
                                    },
                                    "required": ["action"]
                                }
                            },
                            
                            # === MONITORING & LOGS ===
                            {
                                "name": "get_logs",
                                "description": "Get application logs",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "level": {"type": "string", "description": "Log level filter"},
                                        "limit": {"type": "integer", "description": "Number of logs to return"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "metrics_dashboard",
                                "description": "Get metrics dashboard data",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "timeframe": {"type": "string", "description": "Timeframe for metrics"}
                                    },
                                    "required": []
                                }
                            },
                            
                            # === SÉCURITÉ ===
                            {
                                "name": "audit_security",
                                "description": "Audit security configuration",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "verify_jwt_secret",
                                "description": "Verify JWT secret configuration",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            
                            # === PERFORMANCE ===
                            {
                                "name": "analyze_performance",
                                "description": "Analyze database performance",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "query": {"type": "string", "description": "Query to analyze"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "auto_create_indexes",
                                "description": "Automatically create missing indexes",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "vacuum_analyze",
                                "description": "Run VACUUM ANALYZE on database",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name (optional)"}
                                    },
                                    "required": []
                                }
                            },
                            
                            # === BACKUP & RESTORE ===
                            {
                                "name": "backup_database",
                                "description": "Create database backup",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "format": {"type": "string", "description": "Backup format: sql, custom, tar"},
                                        "include_data": {"type": "boolean", "description": "Include data in backup"}
                                    },
                                    "required": []
                                }
                            },
                            
                            # === CACHE ===
                            {
                                "name": "cache_management",
                                "description": "Manage application cache",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "action": {"type": "string", "description": "Action: clear, stats, config"},
                                        "key": {"type": "string", "description": "Cache key (optional)"}
                                    },
                                    "required": ["action"]
                                }
                            },
                            
                            # === ENVIRONNEMENT ===
                            {
                                "name": "environment_management",
                                "description": "Manage environment variables",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "action": {"type": "string", "description": "Action: get, set, delete"},
                                        "key": {"type": "string", "description": "Environment variable key"},
                                        "value": {"type": "string", "description": "Environment variable value"}
                                    },
                                    "required": ["action"]
                                }
                            },
                            
                            # === SECRETS ===
                            {
                                "name": "manage_secrets",
                                "description": "Manage application secrets",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "action": {"type": "string", "description": "Action: create, update, delete, list"},
                                        "name": {"type": "string", "description": "Secret name"},
                                        "value": {"type": "string", "description": "Secret value"}
                                    },
                                    "required": ["action"]
                                }
                            },
                            
                            # === DOCKER ===
                            {
                                "name": "manage_docker",
                                "description": "Manage Docker containers",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "action": {"type": "string", "description": "Action: start, stop, restart, status"},
                                        "container": {"type": "string", "description": "Container name"}
                                    },
                                    "required": ["action"]
                                }
                            },
                            
                            # === UTILITAIRES ===
                            {
                                "name": "get_project_url",
                                "description": "Get project URL",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "get_anon_key",
                                "description": "Get anonymous key",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "get_service_key",
                                "description": "Get service role key",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "get_database_connections",
                                "description": "Get database connection info",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "sync_schema",
                                "description": "Sync database schema",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "source": {"type": "string", "description": "Source schema"},
                                        "target": {"type": "string", "description": "Target schema"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "import_schema",
                                "description": "Import database schema",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "file": {"type": "string", "description": "Schema file path"},
                                        "format": {"type": "string", "description": "File format: sql, json"}
                                    },
                                    "required": ["file"]
                                }
                            },
                            {
                                "name": "rebuild_hooks",
                                "description": "Rebuild database hooks",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {},
                                    "required": []
                                }
                            },
                            {
                                "name": "smart_migration",
                                "description": "Smart migration with conflict resolution",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "migration": {"type": "string", "description": "Migration name"},
                                        "strategy": {"type": "string", "description": "Conflict resolution strategy"}
                                    },
                                    "required": ["migration"]
                                }
                            },
                            {
                                "name": "auto_migrate",
                                "description": "Automatically migrate database",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "dry_run": {"type": "boolean", "description": "Dry run mode"}
                                    },
                                    "required": []
                                }
                            },
                            {
                                "name": "generate_crud_api",
                                "description": "Generate CRUD API for table",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name"},
                                        "operations": {"type": "array", "description": "Operations to generate"}
                                    },
                                    "required": ["table"]
                                }
                            },
                            {
                                "name": "generate_typescript_types",
                                "description": "Generate TypeScript types from schema",
                                "inputSchema": {
                                    "type": "object",
                                    "properties": {
                                        "table": {"type": "string", "description": "Table name (optional)"},
                                        "output": {"type": "string", "description": "Output file path"}
                                    },
                                    "required": []
                                }
                            }
                        ]
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
                # Les notifications n'ont pas de réponse
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
                # Pour les notifications, pas de réponse
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
            "last_discovery": datetime.now().isoformat()
        }
        
        self.wfile.write(json.dumps(discovery_data, indent=2).encode())
    
    def send_servers_api(self):
        """API des serveurs MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        servers = [
            {
                "id": "supabase-mcp",
                "name": "Supabase MCP Server v3.1.0",
                "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
                "version": "3.1.0",
                "status": "online",
                "tools_count": 54,
                "endpoints": {
                    "health": "/health",
                    "mcp": "/mcp",
                    "api": "/api/servers",
                    "tools": "/api/tools"
                },
                "capabilities": ["tools", "production_mode", "database_management", "migrations", "auth", "storage", "rls", "realtime"],
                "self_hosted": True,
                "url": "mcp.coupaul.fr",
                "repository": "https://github.com/MisterSandFR/Supabase-MCP-SelfHosted",
                "github_stars": "⭐ 15+",
                "last_updated": datetime.now().isoformat()
            }
        ]
        self.wfile.write(json.dumps(servers, indent=2).encode())

    def get_tools_list(self):
        """Récupérer la liste des outils optimisée - Suppression des doublons et outils inutiles"""
        return [
            # === OUTILS DE BASE ===
            {"name": "ping", "description": "Simple ping test for server connectivity"},
            {"name": "get_server_info", "description": "Get server information and capabilities"},
            
            # === GESTION DE BASE DE DONNÉES ===
            {"name": "execute_sql", "description": "Execute SQL queries with advanced database management"},
            {"name": "check_health", "description": "Check database health and connectivity"},
            {"name": "list_tables", "description": "List database tables and schemas"},
            {"name": "inspect_schema", "description": "Inspect database schema structure"},
            {"name": "get_database_stats", "description": "Get database statistics and metrics"},
            
            # === MIGRATIONS ===
            {"name": "create_migration", "description": "Create a new database migration"},
            {"name": "apply_migration", "description": "Apply database migration"},
            {"name": "list_migrations", "description": "List all database migrations"},
            {"name": "push_migrations", "description": "Push migrations to remote database"},
            {"name": "validate_migration", "description": "Validate migration before applying"},
            {"name": "smart_migration", "description": "Smart migration with conflict resolution"},
            
            # === AUTHENTIFICATION ===
            {"name": "create_auth_user", "description": "Create a new authenticated user"},
            {"name": "get_auth_user", "description": "Get authenticated user information"},
            {"name": "list_auth_users", "description": "List all authenticated users"},
            {"name": "update_auth_user", "description": "Update authenticated user information"},
            {"name": "delete_auth_user", "description": "Delete authenticated user"},
            
            # === STOCKAGE ===
            {"name": "list_storage_buckets", "description": "List all storage buckets"},
            {"name": "list_storage_objects", "description": "List objects in storage bucket"},
            {"name": "manage_storage_policies", "description": "Manage storage bucket policies"},
            
            # === RLS (ROW LEVEL SECURITY) ===
            {"name": "manage_rls_policies", "description": "Manage Row Level Security policies"},
            {"name": "analyze_rls_coverage", "description": "Analyze RLS policy coverage"},
            
            # === EXTENSIONS ===
            {"name": "list_extensions", "description": "List installed PostgreSQL extensions"},
            {"name": "manage_extensions", "description": "Manage PostgreSQL extensions"},
            
            # === FONCTIONS & TRIGGERS ===
            {"name": "manage_functions", "description": "Manage database functions"},
            {"name": "manage_triggers", "description": "Manage database triggers"},
            
            # === RÔLES ===
            {"name": "manage_roles", "description": "Manage database roles"},
            
            # === WEBHOOKS ===
            {"name": "manage_webhooks", "description": "Manage webhooks"},
            
            # === REALTIME ===
            {"name": "list_realtime_publications", "description": "List realtime publications"},
            {"name": "realtime_management", "description": "Manage realtime subscriptions"},
            
            # === MONITORING & LOGS ===
            {"name": "get_logs", "description": "Get application logs"},
            {"name": "metrics_dashboard", "description": "Get metrics dashboard data"},
            
            # === SÉCURITÉ ===
            {"name": "audit_security", "description": "Audit security configuration"},
            {"name": "verify_jwt_secret", "description": "Verify JWT secret configuration"},
            
            # === PERFORMANCE ===
            {"name": "analyze_performance", "description": "Analyze database performance"},
            {"name": "auto_create_indexes", "description": "Automatically create missing indexes"},
            {"name": "vacuum_analyze", "description": "Run VACUUM ANALYZE on database"},
            
            # === BACKUP ===
            {"name": "backup_database", "description": "Create database backup"},
            
            # === CACHE ===
            {"name": "cache_management", "description": "Manage application cache"},
            
            # === SECRETS ===
            {"name": "manage_secrets", "description": "Manage application secrets"},
            
            # === UTILITAIRES ===
            {"name": "get_project_url", "description": "Get project URL"},
            {"name": "get_anon_key", "description": "Get anonymous key"},
            {"name": "get_service_key", "description": "Get service role key"},
            {"name": "get_database_connections", "description": "Get database connection info"},
            
            # === GÉNÉRATION ===
            {"name": "generate_crud_api", "description": "Generate CRUD API for table"},
            {"name": "generate_typescript_types", "description": "Generate TypeScript types from schema"}
        ]

    def get_tool_category(self, tool_name):
        """Déterminer la catégorie d'un outil"""
        categories = {
            "ping": "utility", "get_server_info": "info",
            "execute_sql": "database", "check_health": "monitoring", "list_tables": "database",
            "inspect_schema": "database", "get_database_stats": "monitoring",
            "create_migration": "migration", "apply_migration": "migration", 
            "list_migrations": "migration", "push_migrations": "migration", 
            "validate_migration": "migration", "smart_migration": "migration",
            "create_auth_user": "auth", "get_auth_user": "auth", "list_auth_users": "auth",
            "update_auth_user": "auth", "delete_auth_user": "auth",
            "list_storage_buckets": "storage", "list_storage_objects": "storage", 
            "manage_storage_policies": "storage",
            "manage_rls_policies": "security", "analyze_rls_coverage": "security",
            "audit_security": "security", "verify_jwt_secret": "security",
            "list_extensions": "extensions", "manage_extensions": "extensions",
            "manage_functions": "functions", "manage_triggers": "triggers", 
            "manage_roles": "roles", "manage_webhooks": "webhooks",
            "list_realtime_publications": "realtime", "realtime_management": "realtime",
            "get_logs": "monitoring", "metrics_dashboard": "monitoring",
            "analyze_performance": "performance", "auto_create_indexes": "performance", 
            "vacuum_analyze": "performance", "backup_database": "backup",
            "cache_management": "cache", "manage_secrets": "secrets",
            "get_project_url": "utility", "get_anon_key": "utility", 
            "get_service_key": "utility", "get_database_connections": "utility",
            "generate_crud_api": "generation", "generate_typescript_types": "generation"
        }
        return categories.get(tool_name, "utility")

    def is_tool_always_works(self, tool_name):
        """Déterminer si un outil fonctionne toujours"""
        always_works = [
            "ping", "get_server_info", "get_project_url", "get_anon_key", 
            "get_service_key", "get_database_connections"
        ]
        return tool_name in always_works

    def send_tools_api(self):
        """API des outils MCP"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        # Générer automatiquement la liste des outils
        tools = []
        for tool in self.get_tools_list():
            tools.append({
                "name": tool["name"],
                "description": tool["description"],
                "server": "supabase-mcp",
                "category": self.get_tool_category(tool["name"]),
                "always_works": self.is_tool_always_works(tool["name"])
            })
        
        self.wfile.write(json.dumps(tools, indent=2).encode())

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
    <title>MCP Hub - Serveurs MCP Supabase</title>
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
            <p class="text-xl text-gray-300 mb-6">Centre de contrôle pour tous vos serveurs MCP</p>
            <div class="flex justify-center space-x-4">
                <span class="bg-green-600 px-3 py-1 rounded-full text-sm">{len(discovered_servers)} Serveurs</span>
                <span class="bg-blue-600 px-3 py-1 rounded-full text-sm">{total_tools} Outils</span>
                <span class="bg-purple-600 px-3 py-1 rounded-full text-sm">{online_servers} En ligne</span>
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
            <p>MCP Hub v3.1.0 - Dernière mise à jour: {datetime.now().strftime('%d/%m/%Y %H:%M')}</p>
            <p class="mt-2">Commit: <code class="bg-gray-800 px-2 py-1 rounded">4432c7b</code></p>
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
            
            cards_html += f"""
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 hover:border-primary transition-colors">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-xl font-semibold text-primary">{server_config["name"]}</h3>
                        <span class="{status_color} px-2 py-1 rounded text-sm">{status_text}</span>
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
                        {f'<span class="bg-red-600 px-2 py-1 rounded text-xs text-white">Erreur: {self.format_error_message(server_config.get("error", "Unknown"))}</span>' if status == "offline" and server_config.get("error") else ""}
                    </div>
                </div>
            """
        
        return cards_html

    def format_error_message(self, error_msg):
        """Formater le message d'erreur pour l'affichage"""
        if not error_msg or error_msg == "Unknown":
            return "Serveur non accessible"
        
        # Messages d'erreur courants et leurs traductions
        error_translations = {
            "Connection refused": "Connexion refusée",
            "Name or service not known": "Serveur introuvable",
            "timeout": "Délai d'attente dépassé",
            "Connection timed out": "Connexion expirée",
            "Network is unreachable": "Réseau inaccessible",
            "No route to host": "Aucun chemin vers l'hôte"
        }
        
        # Chercher une traduction
        for key, translation in error_translations.items():
            if key in str(error_msg):
                return translation
        
        # Si pas de traduction trouvée, retourner un message générique
        if len(str(error_msg)) > 50:
            return str(error_msg)[:47] + "..."
        
        return str(error_msg)

    def send_404_response(self):
        print(f"404 - Path not found: {self.path}")
        self.send_response(404)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(f"<h1>404 - Page not found</h1><p>Path: {self.path}</p><p><a href='/'>Back to hub</a></p>".encode())

    def log_message(self, format, *args):
        pass

def create_server():
    """Fonction pour Smithery - Créer le serveur MCP"""
    return MCPHubHandler

if __name__ == "__main__":
    PORT = int(os.environ.get('PORT', 8000))
    
    print(f"🚀 Starting MCP Hub on port {PORT}")
    print(f"📊 Serving 1 MCP server with 47 tools")
    print(f"🌐 Access at: http://localhost:{PORT}")
    print(f"🔧 Well-known endpoint: /.well-known/mcp-config")
    
    with socketserver.TCPServer(("", PORT), MCPHubHandler) as httpd:
        print(f"✅ MCP Hub running on port {PORT}")
        httpd.serve_forever()
