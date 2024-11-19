from dataclasses import dataclass

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
            youtube=data.get('youtube', 'Not Set')
        )
       
        return model
