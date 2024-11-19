from typing import List
from db_instance import db
from models.card_model import CardModel
from models.faq_model import FaqModel


def get_review_process() -> FaqModel:
    response = db.collection('faq').document('review_process').get()
    data = response.to_dict()
    faq_model = FaqModel.from_json(data)
    return faq_model


def get_submission_guidelines() -> FaqModel:
    response = db.collection('faq').document('submission_guidelines').get()
    data = response.to_dict()
    faq_model = FaqModel.from_json(data)
    return faq_model

def get_rewards_grants() -> List[CardModel]:
    response = db.collection('rewards').get()
    cards = [CardModel.from_json(card.to_dict()) for card in response]
    return cards


