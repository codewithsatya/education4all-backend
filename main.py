from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models
import schemas
from typing import List
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Create database tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Education4All API")

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = models.User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.get("/users/", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = db.query(models.User).offset(skip).limit(limit).all()
    return users

@app.get("/users/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@app.put("/users/{user_id}", response_model=schemas.User)
def update_user(user_id: int, user: schemas.UserUpdate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    for key, value in user.dict(exclude_unset=True).items():
        setattr(db_user, key, value)
    
    db.commit()
    db.refresh(db_user)
    return db_user

@app.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    db.delete(db_user)
    db.commit()
    return {"message": "User deleted successfully"}

@app.post("/tutors/", response_model=schemas.Tutor)
def create_tutor(tutor: schemas.TutorCreate, db: Session = Depends(get_db)):
    db_tutor = models.Tutor(**tutor.dict())
    db.add(db_tutor)
    db.commit()
    db.refresh(db_tutor)
    return db_tutor

@app.get("/tutors/", response_model=List[schemas.Tutor])
def read_tutors(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    tutors = db.query(models.Tutor).offset(skip).limit(limit).all()
    return tutors

@app.get("/tutors/{tutor_id}", response_model=schemas.Tutor)
def read_tutor(tutor_id: int, db: Session = Depends(get_db)):
    db_tutor = db.query(models.Tutor).filter(models.Tutor.id == tutor_id).first()
    if db_tutor is None:
        raise HTTPException(status_code=404, detail="Tutor not found")
    return db_tutor

@app.put("/tutors/{tutor_id}", response_model=schemas.Tutor)
def update_tutor(tutor_id: int, tutor: schemas.TutorUpdate, db: Session = Depends(get_db)):
    db_tutor = db.query(models.Tutor).filter(models.Tutor.id == tutor_id).first()
    if db_tutor is None:
        raise HTTPException(status_code=404, detail="Tutor not found")
    
    for key, value in tutor.dict(exclude_unset=True).items():
        setattr(db_tutor, key, value)
    
    db.commit()
    db.refresh(db_tutor)
    return db_tutor

@app.delete("/tutors/{tutor_id}")
def delete_tutor(tutor_id: int, db: Session = Depends(get_db)):
    db_tutor = db.query(models.Tutor).filter(models.Tutor.id == tutor_id).first()
    if db_tutor is None:
        raise HTTPException(status_code=404, detail="Tutor not found")
    
    db.delete(db_tutor)
    db.commit()
    return {"message": "Tutor deleted successfully"} 