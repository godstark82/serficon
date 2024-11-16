class PageModel:
    def __init__(self, id: str, title: str, content: str):
        self.id = id
        self.title = title 
        self.content = content

    @staticmethod
    def from_json(json: dict):
        return PageModel(
            id=json.get('id', ''),
            title=json.get('title', ''),
            content=json.get('htmlContent', '')
        )

    def to_json(self):
        return {
            'id': self.id,
            'title': self.title,
            'content': self.content
        }
