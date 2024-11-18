import datetime
import os
from flask import Flask, render_template
from db_instance import get_db
from services import home_service, page_service
from routes.about import about_bp
from routes.registration import registration_bp
from routes.guideforauthors import guide_for_authors_bp
from routes.program import program_bp
from routes.contact import contact_bp
from models.article_model import ArticleModel, ArticleStatus

app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'

# Set default values if environment variables are not set
app.config['website_title'] = os.getenv('website_title', 'None')
app.config['navbar_title'] = os.getenv('navbar_title', 'None')
app.config['domain'] = os.getenv('domain', 'http://localhost')

app.register_blueprint(about_bp)
app.register_blueprint(registration_bp)
app.register_blueprint(guide_for_authors_bp)
app.register_blueprint(program_bp)
app.register_blueprint(contact_bp)


@app.errorhandler(404)
def page_not_found(e):
    return render_template('pages/404.html', website_title=app.config['website_title'], 
                           navbar_title=app.config['navbar_title'], 
                           domain=app.config['domain']), 404

@app.route("/")
def Home():
    home = home_service.get_home_data()
    return render_template('index.html', home=home, website_title=app.config['website_title'], navbar_title=app.config['navbar_title'], domain=app.config['domain'])

article = ArticleModel(
    id="1",
    journal_id="journal1",
    abstract_string="Abstract text",
    issue_id="issue1",
    volume_id="vol1",
    document_type="research",
    image="image.jpg",
    keywords=["keyword1", "keyword2"],
    main_subjects=["subject1", "subject2"],
    created_at=datetime.date.today(),
    updated_at=datetime.date.today(),
    pdf="document.pdf",
    references=["ref1", "ref2"],
    status=ArticleStatus.PENDING.value,
    title="Article Title"
)

json_data = article.to_json()


from services.article_service import publish_article

publish_article(article)

if __name__ == '__main__':
    
    app.run(debug=True)
