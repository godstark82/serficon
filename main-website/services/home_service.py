import os
import sys
# Add the project root directory to Python path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(project_root)

from db_instance import db  # Now we can use direct import
from models.home_model import *

from typing import Union


def get_home_data() -> Union[str, List[HomeComponentModel]]:
    response = db.collection('home').get()

    if not response:
        return 'No data found'

    components = [HomeComponentModel.from_json(doc.to_dict()) for doc in response]
    return sorted(components, key=lambda x: x.order)
   
