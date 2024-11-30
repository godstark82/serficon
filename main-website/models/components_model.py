from dataclasses import dataclass
from typing import List

from dataclasses import dataclass
from typing import List, Optional

@dataclass
class NavItem:
    id: str
    title: str
    path: str
    children: List['NavItem']
    is_external: bool = False
    parent_id: Optional[str] = None
    order: int = 0
    page_id: Optional[str] = None

    @classmethod
    def from_json(cls, json_data: dict, id: str) -> 'NavItem':
        return cls(
            id=id,
            title=json_data.get('title', ''),
            path=json_data.get('path', ''),
            is_external=json_data.get('isExternal', False),
            children=[
                NavItem.from_json(child, child['id'])
                for child in json_data.get('children', [])
            ],
            parent_id=json_data.get('parentId'),
            order=json_data.get('order', 0),
            page_id=json_data.get('pageId', "123")
        )
    
    #from dict
    @classmethod
    def from_dict(cls, data: dict) -> 'NavItem':
        return cls.from_json(data, data['id'])

    

@dataclass
class ComponentsModel:
    address: str
    facebook: str
    instagram: str
    linkedin: str
    logo: str
    navtitle: str
    phone: str
    title: str
    twitter: str
    youtube: str
    email: str
    domain: str

    def from_dict(data: dict):
        model = ComponentsModel(
            email=data.get('email', 'Not Set'),
            address=data.get('address', 'Not Set'),
            facebook=data.get('facebook', 'Not Set'),
            instagram=data.get('instagram', 'Not Set'),
            linkedin=data.get('linkedin', 'Not Set'),
            logo=data.get('logo', None),
            navtitle=data.get('navtitle', 'Not Set'),
            phone=data.get('phone', 'Not Set'),
            title=data.get('title', 'Not Set'),
            twitter=data.get('twitter', 'Not Set'),
            youtube=data.get('youtube', 'Not Set'),
            domain=data.get('domain', 'Not Set')
        )
       
        return model
