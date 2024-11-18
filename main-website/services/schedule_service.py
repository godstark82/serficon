
from typing import List
from db_instance import db
from models.schedule_model import DetailedScheduleModel




def get_schedule() -> List[DetailedScheduleModel]:
    response = db.collection('detailed-schedule').get()
    return [DetailedScheduleModel.from_json(item.to_dict()) for item in response]
