
from typing import List
from db_instance import get_db
from models.schedule_model import DetailedScheduleModel


db = get_db()

def get_schedule() -> List[DetailedScheduleModel]:
    response = db.collection('detailed-schedule').get()
    return [DetailedScheduleModel.from_json(item.to_dict()) for item in response]
