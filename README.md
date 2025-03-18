# Education4All Backend API

A FastAPI-based backend API for the Education4All platform, providing endpoints for managing users and tutors.

## Features

- User management (CRUD operations)
- Tutor management (CRUD operations)
- PostgreSQL database integration
- Alembic migrations for database version control
- Environment variable configuration

## Prerequisites

- Python 3.8+
- PostgreSQL database
- pip (Python package manager)

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/education4all-backend.git
cd education4all-backend
```

2. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows, use: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Create a `.env` file in the root directory with the following content:
```
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
```

5. Run database migrations:
```bash
python run_migrations.py
```

## Running the Application

Start the FastAPI server:
```bash
uvicorn main:app --reload
```

The API will be available at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:
- Interactive API documentation (Swagger UI): `http://localhost:8000/docs`
- Alternative API documentation (ReDoc): `http://localhost:8000/redoc`

## API Endpoints

### Users
- `POST /users/` - Create a new user
- `GET /users/` - List all users
- `GET /users/{user_id}` - Get a specific user
- `PUT /users/{user_id}` - Update a user
- `DELETE /users/{user_id}` - Delete a user

### Tutors
- `POST /tutors/` - Create a new tutor
- `GET /tutors/` - List all tutors
- `GET /tutors/{tutor_id}` - Get a specific tutor
- `PUT /tutors/{tutor_id}` - Update a tutor
- `DELETE /tutors/{tutor_id}` - Delete a tutor

## Development

### Database Migrations

To create a new migration:
```bash
alembic revision --autogenerate -m "description"
```

To apply migrations:
```bash
python run_migrations.py
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 