# Tutoring Platform API

A FastAPI-based REST API for a tutoring platform that manages users and tutors.

## Local Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows use: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
python project.py
```

The API will be available at http://localhost:8000

## API Documentation

Once the server is running, you can access:
- Swagger UI documentation: http://localhost:8000/docs
- ReDoc documentation: http://localhost:8000/redoc

## Deployment to Render.com

1. Create a new Web Service on Render.com
2. Connect your GitHub repository
3. Configure the following settings:
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn project:app --host 0.0.0.0 --port $PORT`
   - Environment Variables:
     - `PORT`: 10000 (or as provided by Render)

## API Endpoints

### Users
- POST /users/ - Create a new user
- GET /users/ - Get all users
- POST /users/login/ - Login user
- GET /users/{user_id} - Get user by ID
- PUT /users/{user_id} - Update user

### Tutors
- POST /tutors/ - Create a new tutor
- GET /tutors/ - Get all tutors
- POST /tutors/login/ - Login tutor
- GET /tutors/{tutor_id} - Get tutor by ID
- PUT /tutors/{tutor_id} - Update tutor
- DELETE /tutors/{tutor_id} - Delete tutor 