from models.article_model import ArticleModel
from db_instance import db

def publish_article(article: ArticleModel) -> bool:
    try:
        
        article_ref = db.collection('articles').document(article.id)
        article_ref.set(article.to_json())
        return True
    except Exception as e:
        print(f"Error publishing article: {e}")
        return False