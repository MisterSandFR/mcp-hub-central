import json
import urllib.request
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime
import threading
import time

def load_servers_config_static():
    """Charger la configuration des serveurs MCP (fonction statique)"""
    try:
        with open('mcp_servers_config.json', 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        # Configuration hybride Railway si le fichier n'existe pas
        return {
            "servers": {
                "supabase": {
                    "name": "Supabase MCP Server",
                    "version": "3.1.0",
                    "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
                    "host": "supabase.mcp.coupaul.fr",
                    "port": 443,
                    "path": "/supabase",
                    "protocol": "https",
                    "status": "active",
                    "tools_count": 54,
                    "categories": ["database", "auth", "storage", "realtime", "security", "migration", "monitoring", "performance"],
                    "github_url": "https://github.com/MisterSandFR/Supabase-MCP-SelfHosted",
                    "always_works": True,
                    "domain": "supabase.mcp.coupaul.fr",
                    "mcp_endpoint": "/mcp",
                    "health_endpoint": "/health",
                    "supabase_url": "https://api.recube.gg/",
                    "anon_key": "eyJhbGciOiJIUzI1NiIs...",
                    "production_mode": True,
                    "discovery_path": "/health",
                    "discovery_timeout": 10
                },
                "minecraft": {
                    "name": "Minecraft MCPC+ 1.6.4 Server",
                    "version": "1.6.4",
                    "description": "MCPC+ 1.6.4 server management and automation with MCP tools - Compatible with MCP Hub Central",
                    "host": "minecraft-mcp-forge-164.railway.internal",
                    "port": 3000,
                    "path": "/minecraft",
                    "protocol": "http",
                    "status": "active",
                    "tools_count": 4,
                    "categories": ["gaming", "server_management", "automation", "world_management", "mcpc"],
                    "github_url": "https://github.com/[USERNAME]/minecraft-mcpc-mcp-server",
                    "always_works": False,
                    "domain": "minecraft.mcp.coupaul.fr",
                    "deployment": "railway",
                    "mcpc_version": "1.6.4",
                    "docker_enabled": True,
                    "discovery_path": "/health",
                    "discovery_timeout": 5,
                    "timeout": 10,
                    "retry_attempts": 1,
                    "health_check_timeout": 10
                }
            },
            "hub": {
                "name": "MCP Hub Central",
                "version": "3.6.0",
                "description": "Multi-server MCP hub for centralized management - Hybrid configuration (Supabase public + Minecraft Railway internal)",
                "total_servers": 2,
                "total_tools": 58,
                "domain": "mcp.coupaul.fr",
                "features": [
                    "automatic_discovery",
                    "intelligent_routing",
                    "load_balancing",
                    "centralized_monitoring",
                    "unified_interface",
                    "advanced_security",
                    "real_time_metrics",
                    "hybrid_configuration"
                ]
            },
            "routing": {
                "strategy": "capability_based",
                "fallback_server": "supabase",
                "load_balancing": {
                    "enabled": True,
                    "algorithm": "round_robin",
                    "health_check_interval": 120
                }
            },
            "security": {
                "jwt_auth": True,
                "rate_limiting": {
                    "enabled": True,
                    "requests_per_minute": 100,
                    "burst_limit": 20
                },
                "cors": {
                    "enabled": True,
                    "allowed_origins": ["*"],
                    "allowed_methods": ["GET", "POST", "OPTIONS"],
                    "allowed_headers": ["Content-Type", "Authorization"]
                }
            },
            "monitoring": {
                "enabled": True,
                "metrics_endpoint": "/api/metrics",
                "health_check_interval": 120,
                "cache_duration": 300,
                "discovery_timeout": 10,
                "alerting": {
                    "enabled": True,
                    "email": "alerts@mcp.coupaul.fr",
                    "webhook": "https://hooks.slack.com/services/..."
                }
            }
        }

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
            # Configuration hybride Railway si le fichier n'existe pas
            return {
                "servers": {
                    "supabase": {
                        "name": "Supabase MCP Server",
                        "version": "3.1.0",
                        "description": "Enhanced Edition v3.1 - 54+ MCP tools for 100% autonomous Supabase management",
                        "host": "supabase.mcp.coupaul.fr",
                        "port": 443,
                        "path": "/supabase",
                        "protocol": "https",
                        "status": "active",
                        "tools_count": 54,
                        "categories": ["database", "auth", "storage", "realtime", "security", "migration", "monitoring", "performance"],
                        "github_url": "https://github.com/MisterSandFR/Supabase-MCP-SelfHosted",
                        "always_works": True,
                        "domain": "supabase.mcp.coupaul.fr",
                        "mcp_endpoint": "/mcp",
                        "health_endpoint": "/health",
                        "supabase_url": "https://api.recube.gg/",
                        "anon_key": "eyJhbGciOiJIUzI1NiIs...",
                        "production_mode": True,
                        "discovery_path": "/health",
                        "discovery_timeout": 5
                    },
                    "minecraft": {
                        "name": "Minecraft MCPC+ 1.6.4 Server",
                        "version": "1.6.4",
                        "description": "MCPC+ 1.6.4 server management and automation with MCP tools - Compatible with MCP Hub Central",
                        "host": "minecraft-mcp-forge-164.railway.internal",
                        "port": 3000,
                        "path": "/minecraft",
                        "protocol": "http",
                        "status": "active",
                        "tools_count": 4,
                        "categories": ["gaming", "server_management", "automation", "world_management", "mcpc"],
                        "github_url": "https://github.com/[USERNAME]/minecraft-mcpc-mcp-server",
                        "always_works": False,
                        "domain": "minecraft.mcp.coupaul.fr",
                        "deployment": "railway",
                        "mcpc_version": "1.6.4",
                        "docker_enabled": True,
                        "discovery_path": "/health",
                        "discovery_timeout": 5,
                        "timeout": 10,
                        "retry_attempts": 1,
                        "health_check_timeout": 10
                    }
                },
                "hub": {
                    "name": "MCP Hub Central",
                    "version": "3.6.0",
                    "description": "Multi-server MCP hub for centralized management - Hybrid configuration (Supabase public + Minecraft Railway internal)",
                    "total_servers": 2,
                    "total_tools": 58,
                    "domain": "mcp.coupaul.fr",
                    "features": [
                        "automatic_discovery",
                        "intelligent_routing",
                        "load_balancing",
                        "centralized_monitoring",
                        "unified_interface",
                        "advanced_security",
                        "real_time_metrics",
                        "hybrid_configuration"
                    ]
                },
                "routing": {
                    "strategy": "capability_based",
                    "fallback_server": "supabase",
                    "load_balancing": {
                        "enabled": True,
                        "algorithm": "round_robin",
                        "health_check_interval": 120
                    }
                },
                "security": {
                    "jwt_auth": True,
                    "rate_limiting": {
                        "enabled": True,
                        "requests_per_minute": 100,
                        "burst_limit": 20
                    },
                    "cors": {
                        "enabled": True,
                        "allowed_origins": ["*"],
                        "allowed_methods": ["GET", "POST", "OPTIONS"],
                        "allowed_headers": ["Content-Type", "Authorization"]
                    }
                },
                "monitoring": {
                    "enabled": True,
                    "metrics_endpoint": "/api/metrics",
                    "health_check_interval": 120,
                    "cache_duration": 300,
                    "discovery_timeout": 10,
                    "alerting": {
                        "enabled": True,
                        "email": "alerts@mcp.coupaul.fr",
                        "webhook": "https://hooks.slack.com/services/..."
                    }
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
                    else:
                        print(f"Server {server_id} discovery failed: {e}")
                
                discovered_servers[server_id] = server_config
        
        return discovered_servers

    def do_GET(self):
        """Gérer les requêtes GET"""
        if self.path == '/':
            self.serve_hub_page()
        elif self.path == '/health':
            self.serve_health()
        elif self.path == '/api/servers':
            self.serve_servers_api()
        elif self.path == '/api/tools':
            self.serve_tools_api()
        elif self.path == '/.well-known/mcp-config':
            self.serve_mcp_config()
        else:
            self.send_error(404)

    def serve_hub_page(self):
        """Servir la page principale du hub"""
        discovered_servers = self.discover_servers()
        
        # Générer le HTML
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>MCP Hub Central</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {{ font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }}
                .container {{ max-width: 1200px; margin: 0 auto; }}
                .header {{ background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }}
                .servers {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }}
                .server {{ background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }}
                .status {{ padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }}
                .online {{ background: #d4edda; color: #155724; }}
                .offline {{ background: #f8d7da; color: #721c24; }}
                .tools {{ margin-top: 10px; font-size: 14px; color: #666; }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🚀 MCP Hub Central</h1>
                    <p>Version {self.servers_config['hub']['version']} - {len(discovered_servers)} serveurs actifs</p>
                </div>
                <div class="servers">
        """
        
        for server_id, server_config in discovered_servers.items():
            status_class = "online" if server_config.get("health_status") == "online" else "offline"
            status_text = "ONLINE" if server_config.get("health_status") == "online" else "OFFLINE"
            
            html += f"""
                    <div class="server">
                        <h3>{server_config['name']}</h3>
                        <p>{server_config['description']}</p>
                        <span class="status {status_class}">{status_text}</span>
                        <div class="tools">
                            <strong>{server_config.get('available_tools', 0)} outils disponibles</strong>
                        </div>
                    </div>
            """
        
        html += """
                </div>
            </div>
        </body>
        </html>
        """
        
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(html.encode('utf-8'))

    def serve_health(self):
        """Servir l'endpoint de santé"""
        discovered_servers = self.discover_servers()
        online_servers = sum(1 for s in discovered_servers.values() if s.get("health_status") == "online")
        
        health_data = {
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "version": self.servers_config['hub']['version'],
            "servers": {
                "total": len(discovered_servers),
                "online": online_servers,
                "offline": len(discovered_servers) - online_servers
            }
        }
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(health_data, indent=2).encode('utf-8'))

    def serve_servers_api(self):
        """Servir l'API des serveurs"""
        discovered_servers = self.discover_servers()
        
        # Convertir en format API
        servers_list = []
        for server_id, server_config in discovered_servers.items():
            server_api = {
                "id": server_id,
                "name": server_config['name'],
                "version": server_config['version'],
                "description": server_config['description'],
                "status": "online" if server_config.get("health_status") == "online" else "offline",
                "tools_count": server_config.get('available_tools', 0),
                "endpoints": {
                    "health": "/health",
                    "mcp": "/mcp",
                    "api": "/api/servers",
                    "tools": "/api/tools"
                },
                "capabilities": server_config.get('categories', []),
                "self_hosted": True,
                "url": self.servers_config['hub']['domain'],
                "repository": server_config.get('github_url', ''),
                "github_stars": "⭐ 15+",
                "last_updated": server_config.get('last_seen', datetime.now().isoformat())
            }
            servers_list.append(server_api)
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(servers_list, indent=2).encode('utf-8'))

    def serve_tools_api(self):
        """Servir l'API des outils"""
        discovered_servers = self.discover_servers()
        
        all_tools = []
        for server_id, server_config in discovered_servers.items():
            if server_config.get("health_status") == "online":
                tools = server_config.get("tools", [])
                for tool in tools:
                    tool["server"] = server_id
                    all_tools.append(tool)
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(all_tools, indent=2).encode('utf-8'))

    def serve_mcp_config(self):
        """Servir la configuration MCP"""
        discovered_servers = self.discover_servers()
        
        mcp_config = {
            "mcpServers": {},
            "capabilities": {
                "tools": True,
                "resources": False,
                "prompts": False
            },
            "server": {
                "name": self.servers_config['hub']['name'],
                "version": self.servers_config['hub']['version'],
                "description": self.servers_config['hub']['description'],
                "url": f"https://{self.servers_config['hub']['domain']}/mcp",
                "endpoints": {
                    "mcp": "/mcp",
                    "health": "/health",
                    "config": "/.well-known/mcp-config",
                    "servers": "/api/servers",
                    "tools": "/api/tools"
                },
                "servers": []
            }
        }
        
        for server_id, server_config in discovered_servers.items():
            if server_config.get("health_status") == "online":
                mcp_config["server"]["servers"].append({
                    "id": server_id,
                    "name": server_config['name'],
                    "url": f"{server_config['protocol']}://{server_config['host']}:{server_config['port']}",
                    "status": "online"
                })
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(mcp_config, indent=2).encode('utf-8'))

def run_server(port=8080):
    """Démarrer le serveur MCP Hub"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, MCPHubHandler)
    
    print(f"🚀 Starting MCP Hub on port {port}")
    
    # Découvrir les serveurs au démarrage
    try:
        # Créer une instance temporaire pour découvrir les serveurs
        temp_handler = MCPHubHandler.__new__(MCPHubHandler)
        temp_handler.servers_config = load_servers_config_static()
        discovered_servers = temp_handler.discover_servers()
        total_tools = sum(s.get('available_tools', 0) for s in discovered_servers.values())
        
        print(f"📊 Serving {len(discovered_servers)} MCP servers with {total_tools} tools")
    except Exception as e:
        print(f"⚠️ Error discovering servers: {e}")
        print(f"📊 Serving 2 MCP servers with 58 tools (estimated)")
    
    print(f"🌐 Access at: http://localhost:{port}")
    print(f"🔧 Well-known endpoint: /.well-known/mcp-config")
    print(f"✅ MCP Hub running on port {port}")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 MCP Hub stopped")
        httpd.shutdown()

if __name__ == "__main__":
    run_server()
