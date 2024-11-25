from db_instance import db
from models.committee_model import CommitteeMemberModel

def get_committee_members()-> CommitteeMemberModel:
    doc = db.collection('components').get()
    return CommitteeMemberModel.from_dict(data=doc.to_dict())