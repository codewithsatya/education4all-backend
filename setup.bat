@echo off
setlocal enabledelayedexpansion

:: Colors for output
set "GREEN=[32m"
set "RED=[31m"
set "YELLOW=[33m"
set "NC=[0m"

echo %GREEN%Starting setup for Tutoring Platform API...%NC%

:: Check if Python 3.11 is installed
python --version 2>nul | findstr "3.11" >nul
if errorlevel 1 (
    echo %RED%Python 3.11 is not installed. Please install it first.%NC%
    echo You can install it using:
    echo   - Download from https://www.python.org/downloads/release/python-3110/
    echo   - Or use winget: winget install Python.Python.3.11
    exit /b 1
)

:: Create requirements.txt if it doesn't exist
if not exist requirements.txt (
    echo %GREEN%Creating requirements.txt...%NC%
    (
        echo fastapi==0.109.2
        echo uvicorn==0.27.1
        echo sqlalchemy==2.0.27
        echo pydantic==2.6.1
        echo python-multipart==0.0.9
    ) > requirements.txt
    echo %GREEN%requirements.txt created successfully!%NC%
)

:: Check if virtual environment exists
if not exist venv (
    echo %GREEN%Creating virtual environment...%NC%
    python -m venv venv
)

:: Activate virtual environment
echo %GREEN%Activating virtual environment...%NC%
call venv\Scripts\activate.bat

:: Upgrade pip
echo %GREEN%Upgrading pip...%NC%
python -m pip install --upgrade pip

:: Install requirements
echo %GREEN%Installing requirements...%NC%
pip install -r requirements.txt

if errorlevel 1 (
    echo %RED%Installation failed. Please check the errors above.%NC%
    exit /b 1
)

echo %GREEN%Installation completed successfully!%NC%

:: Check if database exists
if not exist tutoring.db (
    echo %GREEN%Setting up the database...%NC%
    python -c "from sqlalchemy import create_engine; from sqlalchemy.ext.declarative import declarative_base; from project import Base, engine; Base.metadata.create_all(bind=engine)"
    echo %GREEN%Database setup completed!%NC%
) else (
    echo %YELLOW%Database already exists. Skipping database setup.%NC%
)

echo %GREEN%Starting the application...%NC%
echo %GREEN%You can access the API at:%NC%
echo   - Main API: http://localhost:8000
echo   - Swagger UI: http://localhost:8000/docs
echo   - ReDoc: http://localhost:8000/redoc
echo %GREEN%Available API Endpoints:%NC%
echo   Users:
echo     - POST /users/ - Create a new user
echo     - GET /users/ - Get all users
echo     - POST /users/login/ - Login user
echo     - GET /users/{user_id} - Get user by ID
echo     - PUT /users/{user_id} - Update user
echo   Tutors:
echo     - POST /tutors/ - Create a new tutor
echo     - GET /tutors/ - Get all tutors
echo     - POST /tutors/login/ - Login tutor
echo     - GET /tutors/{tutor_id} - Get tutor by ID
echo     - PUT /tutors/{tutor_id} - Update tutor
echo     - DELETE /tutors/{tutor_id} - Delete tutor
echo %GREEN%Press Ctrl+C to stop the server%NC%

python project.py 