import os
from alembic.config import Config
from alembic import command
from dotenv import load_dotenv

def run_migrations():
    # Load environment variables
    load_dotenv()
    
    # Get the database URL
    database_url = os.getenv("DATABASE_URL")
    
    # Create Alembic configuration
    alembic_cfg = Config("alembic.ini")
    
    # Update the database URL in the configuration
    alembic_cfg.set_main_option("sqlalchemy.url", database_url)
    
    # Run the migration
    command.upgrade(alembic_cfg, "head")

if __name__ == "__main__":
    run_migrations() 