from typing import List
from db_instance import db
from models.card_model import CardModel
from models.faq_model import FaqModel


def get_rewards_grants() -> List[CardModel]:
    response = db.collection('rewards').get()
    cards = [CardModel.from_json(card.to_dict()) for card in response]
    return cards


