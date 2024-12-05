from dataclasses import dataclass
from datetime import datetime
from typing import List
from enum import Enum

class ArticleStatus(Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"

class AuthorModel:
    name:str
    email:str
    affiliation:str

    # fromDict
    def from_dict(self, data:dict):
        self.name = data.get('name')
        self.email = data.get('email')
        self.affiliation = data.get('affiliation')
        

    # toJson
    def to_json(self) -> dict:
        return {
            'name': self.name,
            'email': self.email,
            'affiliation': self.affiliation
        }

@dataclass
class ArticleModel:
    id: str
    title: str
    email:str
    article_title:str
    document_type:str
    affiliation:str
    status:ArticleStatus
    abstract:str
    keywords:List[str]
    paper_type:List[str]
    pdf_url:str
    authors:List[AuthorModel]



    def to_json(self) -> dict:
        return {
            'title': self.title,
            'email': self.email,
            'article_title': self.article_title,
            'document_type': self.document_type,
            'affiliation': self.affiliation,
            'abstract': self.abstract,
            'keywords': self.keywords,
            'paper_type': self.paper_type,
            'pdf_url': self.pdf_url,
            'authors': [author.to_json() for author in self.authors],
            'status': self.status.value
        }