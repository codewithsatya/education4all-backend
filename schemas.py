from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr
    full_name: str

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    password: Optional[str] = None

class User(UserBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class TutorBase(BaseModel):
    email: EmailStr
    full_name: str
    subject: str

class TutorCreate(TutorBase):
    password: str

class TutorUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    subject: Optional[str] = None
    password: Optional[str] = None

class Tutor(TutorBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True 