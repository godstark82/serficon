from typing import List
from db_instance import db
from models.components_model import ComponentsModel, NavItem

def get_navbar_items()-> List[NavItem]:
    doc = db.collection('navigation').get()
    nav_items = [NavItem.from_dict(data=item.to_dict()) for item in doc]
    
    for item in nav_items:
        item.children = sorted(item.children, key=lambda x: x.order)
    
    return sorted(nav_items, key=lambda x: x.order)

def get_all_components()-> ComponentsModel:
    doc = db.collection('components').document('settings').get()
    return ComponentsModel.from_dict(data=doc.to_dict())

