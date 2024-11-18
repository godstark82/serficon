from dataclasses import dataclass
from datetime import datetime
from typing import List
from enum import Enum

class ArticleStatus(Enum):
    PENDING = "Pending"
    ACCEPTED = "Accepted"
    REJECTED = "Rejected"

@dataclass
class ArticleModel:
    id: str
    journal_id: str
    abstract_string: str
    issue_id: str
    volume_id: str
    document_type: str
    image: str
    keywords: List[str]
    main_subjects: List[str]
    created_at: datetime
    updated_at: datetime
    pdf: str
    references: List[str]
    status: str
    title: str

    def to_json(self) -> dict:
        return {
            'id': self.id,
            'journalId': self.journal_id,
            'abstractString': self.abstract_string,
            'issueId': self.issue_id,
            'volumeId': self.volume_id,
            'documentType': self.document_type,
            'image': self.image,
            'keywords': self.keywords,
            'mainSubjects': self.main_subjects,
            'createdAt': self.created_at.isoformat(),
            'updatedAt': self.updated_at.isoformat(),
            'pdf': self.pdf,
            'references': self.references,
            'title': self.title,
            'status': self.status
        }