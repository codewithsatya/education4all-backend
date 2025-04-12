#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting setup for Tutoring Platform API...${NC}"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${GREEN}Creating virtual environment...${NC}"
    python -m venv venv
fi

# Activate virtual environment (Windows specific)
echo -e "${GREEN}Activating virtual environment...${NC}"
# For PowerShell or Git Bash
.\\venv\\Scripts\\activate
# For cmd.exe (if using Command Prompt)
# venv\\Scripts\\activate.bat

# Ensure pip is available
if ! command -v pip &> /dev/null; then
    echo -e "${RED}pip not found in the virtual environment, installing...${NC}"
    python -m ensurepip --upgrade
    python -m pip install --upgrade pip
fi

# Upgrade pip to the latest version
echo -e "${GREEN}Upgrading pip...${NC}"
pip install --upgrade pip

# Create requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    echo -e "${GREEN}Creating requirements.txt...${NC}"
    cat > requirements.txt << EOL
fastapi==0.109.2
uvicorn==0.27.1
sqlalchemy==2.0.27
pydantic==2.6.1
python-multipart==0.0.9
EOL
    echo -e "${GREEN}requirements.txt created successfully!${NC}"
fi

# Install requirements (use --user to avoid permission issues)
echo -e "${GREEN}Installing requirements...${NC}"
pip install --user -r requirements.txt

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Installation completed successfully!${NC}"
    
    # Check if database exists
    if [ ! -f "tutoring.db" ]; then
        echo -e "${GREEN}Setting up the database...${NC}"
        # Run Python script to create database
        python -c "
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from project import Base, engine

# Create all tables
Base.metadata.create_all(bind=engine)
"
        echo -e "${GREEN}Database setup completed!${NC}"
    else
        echo -e "${YELLOW}Database already exists. Skipping database setup.${NC}"
    fi

    echo -e "${GREEN}Starting the application...${NC}"
    python project.py
else
    echo -e "${RED}Installation failed. Please check the errors above.${NC}"
    exit 1
fi

