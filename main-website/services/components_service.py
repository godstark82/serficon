from db_instance import db
from models.components_model import ComponentsModel

def get_all_components()-> ComponentsModel:
    doc = db.collection('components').document('settings').get()
    return ComponentsModel.from_dict(data=doc.to_dict())

