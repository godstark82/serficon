from db_instance import db
from models.page_model import PageModel



def get_page_content(page_id: str) -> PageModel:
    try:
        # Assuming firestore is already initialized
        page = db.collection('pages').document(page_id).get()
        return PageModel.from_json(page.to_dict())
    except Exception as e:
        print(f"Error: {str(e)}")
        return {'error': str(e)}

def get_all_about_pages() -> list[PageModel]:
    try:
        pages = db.collection('about').get()
        return [PageModel.from_json(page.to_dict()) for page in pages]
    except Exception as e:
        print(f"Error: {str(e)}")
        return []

def get_single_about_page(page_id: str) -> PageModel:
    try:
        page = db.collection('about').document(page_id).get()
        return PageModel.from_json(page.to_dict())
    except Exception as e:
        print(f"Error: {str(e)}")
        return None
