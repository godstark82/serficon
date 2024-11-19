from models.components_model import ComponentsModel
from db_instance import db
class ComponentsService:
    def __init__(self):
        self.components = []

    def get_all_components(self) -> list:
        return [component.to_json() for component in self.components]

    def find_component_by_title(self, title: str) -> dict:
        for component in self.components:
            if component.title == title:
                return component.to_json()
        return {}
