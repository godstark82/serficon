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

    def to_json(self) -> dict:
        return {
            'address': self.address,
            'facebook': self.facebook,
            'instagram': self.instagram,
            'linkedin': self.linkedin,
            'logo': self.logo,
            'navtitle': self.navtitle,
            'phone': self.phone,
            'title': self.title,
            'twitter': self.twitter,
            'youtube': self.youtube
        }