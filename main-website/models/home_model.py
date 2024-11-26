from dataclasses import dataclass, field
from typing import List, Optional
from enum import Enum

@dataclass
class CardModel:
    title: Optional[str] = None
    description: Optional[str] = None
    image: Optional[str] = None

    @classmethod
    def from_json(cls, json_data: dict) -> 'CardModel':
        return cls(
            title=json_data.get('title'),
            description=json_data.get('description'),
            image=json_data.get('image')
        )


@dataclass
class StreamCardModel:
    title: Optional[str] = None
    descriptions: Optional[List[str]] = field(default_factory=list)

    @classmethod
    def from_json(cls, json_data: dict) -> 'StreamCardModel':
        return cls(
            title=json_data.get('title'),
            descriptions=json_data.get('descriptions', [])
        )



class HomeComponentType(Enum):
    WITH_CARDS = "with_cards"
    WITH_STREAM = "with_stream"

    @classmethod
    def from_json(cls, value: str) -> 'HomeComponentType':
        return cls(value)

@dataclass
class HomeComponentModel:
    id: str
    title: str
    html_content: str
    display: bool
    type: HomeComponentType
    order: int
    description: Optional[str] = None
    bg_color: str = 'transparent'
    cards: List[CardModel] = field(default_factory=list)
    stream_cards: List[StreamCardModel] = field(default_factory=list)

    @classmethod
    def from_json(cls, json_data: dict) -> 'HomeComponentModel':
        color = 'transparent'
        colorDict = json_data.get('bgColor')
        if colorDict:
            color = colorDict
        return cls(
            description=json_data.get('description'),
            bg_color=color,
            order=json_data.get('order', 0),
            type=HomeComponentType.from_json(json_data['type']),
            cards=[CardModel.from_json(x) for x in json_data.get('cards', [])],
            stream_cards=[StreamCardModel.from_json(x) for x in json_data.get('streamCards', [])],
            id=json_data['id'],
            title=json_data['title'],
            html_content=json_data['htmlContent'],
            display=json_data['display']
        )

    def __str__(self) -> str:
        return (f'HomeComponentModel(title: {self.title}, '
                f'type: {self.type}, description: {self.description}, '
                f'bg_color: {self.bg_color})')