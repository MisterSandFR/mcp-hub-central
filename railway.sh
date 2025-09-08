# Railway deployment script
# This script ensures proper deployment

#!/bin/bash

echo "🚀 Railway Deployment Script"

# Install dependencies
pip install -r requirements.txt

# Start the application
python mcp_hub_central.py
