from 
import FastAPI, HTTPException, Depends # type: ignore
from pydantic import BaseModel # type: ignore
from typing import List, Optional
from datetime import datetime
from sqlalchemy import create_engine, Column, Integer, String, DateTime # type: ignore
from sqlalchemy.ext.declarative import declarative_base # type: ignore
from sqlalchemy.orm import sessionmaker, Session # type: ignore

app = FastAPI()

# Database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./tutoring.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Models
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    full_name = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

class Tutor(Base):
    __tablename__ = "tutors"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    full_name = Column(String)
    subject = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

Base.metadata.create_all(bind=engine)

# Schemas
class UserBase(BaseModel):
    email: str
    full_name: str

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class UserResponse(UserBase):
    id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

class TutorBase(BaseModel):
    email: str
    full_name: str
    subject: str

class TutorCreate(TutorBase):
    password: str

class TutorLogin(BaseModel):
    email: str
    password: str

class TutorResponse(TutorBase):
    id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# User endpoints
@app.post("/users/", response_model=UserResponse)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = User(
        email=user.email,
        password=user.password,  # In production, hash the password
        full_name=user.full_name
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.get("/users/", response_model=List[UserResponse])
def get_all_users(db: Session = Depends(get_db)):
    return db.query(User).all()

@app.post("/users/login/")
def login_user(user_login: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == user_login.email).first()
    if not user or user.password != user_login.password:  # In production, verify hashed password
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"message": "Login successful"}

@app.get("/users/{user_id}", response_model=UserResponse)
def get_user_by_id(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/users/{user_id}", response_model=UserResponse)
def update_user(user_id: int, user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    db_user.email = user.email
    db_user.password = user.password  # In production, hash the password
    db_user.full_name = user.full_name
    
    db.commit()
    db.refresh(db_user)
    return db_user

# Tutor endpoints
@app.post("/tutors/", response_model=TutorResponse)
def create_tutor(tutor: TutorCreate, db: Session = Depends(get_db)):
    db_tutor = Tutor(
        email=tutor.email,
        password=tutor.password,  # In production, hash the password
        full_name=tutor.full_name,
        subject=tutor.subject
    )
    db.add(db_tutor)
    db.commit()
    db.refresh(db_tutor)
    return db_tutor

@app.post("/tutors/login/")
def login_tutor(tutor_login: TutorLogin, db: Session = Depends(get_db)):
    tutor = db.query(Tutor).filter(Tutor.email == tutor_login.email).first()
    if not tutor or tutor.password != tutor_login.password:  # In production, verify hashed password
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"message": "Login successful"}

@app.get("/tutors/", response_model=List[TutorResponse])
def get_all_tutors(db: Session = Depends(get_db)):
    return db.query(Tutor).all()

@app.get("/tutors/{tutor_id}", response_model=TutorResponse)
def get_tutor_by_id(tutor_id: int, db: Session = Depends(get_db)):
    tutor = db.query(Tutor).filter(Tutor.id == tutor_id).first()
    if not tutor:
        raise HTTPException(status_code=404, detail="Tutor not found")
    return tutor

@app.put("/tutors/{tutor_id}", response_model=TutorResponse)
def update_tutor(tutor_id: int, tutor: TutorCreate, db: Session = Depends(get_db)):
    db_tutor = db.query(Tutor).filter(Tutor.id == tutor_id).first()
    if not db_tutor:
        raise HTTPException(status_code=404, detail="Tutor not found")
    
    db_tutor.email = tutor.email
    db_tutor.password = tutor.password  # In production, hash the password
    db_tutor.full_name = tutor.full_name
    db_tutor.subject = tutor.subject
    
    db.commit()
    db.refresh(db_tutor)
    return db_tutor

@app.delete("/tutors/{tutor_id}")
def delete_tutor(tutor_id: int, db: Session = Depends(get_db)):
    db_tutor = db.query(Tutor).filter(Tutor.id == tutor_id).first()
    if not db_tutor:
        raise HTTPException(status_code=404, detail="Tutor not found")
    
    db.delete(db_tutor)
    db.commit()
    return {"message": "Tutor deleted successfully"}

if __name__ == "__main__":
    import uvicorn # type: ignore
    uvicorn.run(app, host="5.1.7.3", port=8000)