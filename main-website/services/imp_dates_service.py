from typing import List
from db_instance import db
from models.imp_dates import DateModel



def get_imp_dates() -> List[DateModel]:
    response = db.collection('dates').document('important-dates').get()
    data = response.to_dict()
    date_models = [DateModel.from_json(date) for date in data['dates']]
    return date_models

