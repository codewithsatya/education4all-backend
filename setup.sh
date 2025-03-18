#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting setup for Tutoring Platform API...${NC}"

# Function to install Python based on OS
install_python() {
    local os_type=$1
    case $os_type in
        "macos")
            echo -e "${GREEN}Installing Python 3.11 using Homebrew...${NC}"
            if ! command -v brew &> /dev/null; then
                echo -e "${GREEN}Installing Homebrew first...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install python@3.11
            ;;
        "ubuntu")
            echo -e "${GREEN}Installing Python 3.11 on Ubuntu...${NC}"
            sudo add-apt-repository ppa:deadsnakes/ppa
            sudo apt update
            sudo apt install python3.11 python3.11-venv
            ;;
        "debian")
            echo -e "${GREEN}Installing Python 3.11 on Debian...${NC}"
            sudo apt update
            sudo apt install software-properties-common
            sudo add-apt-repository ppa:deadsnakes/ppa
            sudo apt update
            sudo apt install python3.11 python3.11-venv
            ;;
        "windows")
            echo -e "${GREEN}Please install Python 3.11 manually on Windows:${NC}"
            echo "1. Download Python 3.11 from: https://www.python.org/downloads/release/python-3110/"
            echo "2. Run the installer"
            echo "3. Make sure to check 'Add Python to PATH' during installation"
            echo "4. Restart your terminal after installation"
            exit 1
            ;;
        *)
            echo -e "${RED}Unsupported operating system${NC}"
            exit 1
            ;;
    esac
}

# Detect operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        OS="linux"
    fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    echo -e "${RED}Unsupported operating system${NC}"
    exit 1
fi

# Check if Python 3.11 is installed
if ! command -v python3.11 &> /dev/null; then
    echo -e "${RED}Python 3.11 is not installed.${NC}"
    echo -e "${GREEN}Would you like to install Python 3.11? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        install_python "$OS"
    else
        echo -e "${RED}Python 3.11 is required to run this application.${NC}"
        exit 1
    fi
fi

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

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${GREEN}Creating virtual environment...${NC}"
    python3.11 -m venv venv
fi

# Activate virtual environment
echo -e "${GREEN}Activating virtual environment...${NC}"
source venv/bin/activate

# Upgrade pip
echo -e "${GREEN}Upgrading pip...${NC}"
pip install --upgrade pip

# Install requirements
echo -e "${GREEN}Installing requirements...${NC}"
pip install -r requirements.txt

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Installation completed successfully!${NC}"
    
    # Check if database exists
    if [ ! -f "tutoring.db" ]; then
        echo -e "${GREEN}Setting up the database...${NC}"
        # Run Python script to create database
        python3 -c "
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
    echo -e "${GREEN}You can access the API at:${NC}"
    echo -e "  - Main API: http://localhost:8000"
    echo -e "  - Swagger UI: http://localhost:8000/docs"
    echo -e "  - ReDoc: http://localhost:8000/redoc"
    echo -e "${GREEN}Available API Endpoints:${NC}"
    echo -e "  Users:"
    echo -e "    - POST /users/ - Create a new user"
    echo -e "    - GET /users/ - Get all users"
    echo -e "    - POST /users/login/ - Login user"
    echo -e "    - GET /users/{user_id} - Get user by ID"
    echo -e "    - PUT /users/{user_id} - Update user"
    echo -e "  Tutors:"
    echo -e "    - POST /tutors/ - Create a new tutor"
    echo -e "    - GET /tutors/ - Get all tutors"
    echo -e "    - POST /tutors/login/ - Login tutor"
    echo -e "    - GET /tutors/{tutor_id} - Get tutor by ID"
    echo -e "    - PUT /tutors/{tutor_id} - Update tutor"
    echo -e "    - DELETE /tutors/{tutor_id} - Delete tutor"
    echo -e "${GREEN}Press Ctrl+C to stop the server${NC}"
    python3 project.py
else
    echo -e "${RED}Installation failed. Please check the errors above.${NC}"
    exit 1
fi 