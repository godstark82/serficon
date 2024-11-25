import os
from flask import Flask, render_template, current_app
from db_instance import get_db
from services import components_service
from routes.about import about_bp
from routes.registration import registration_bp
from routes.acceptanceofpaper import acceptance_of_paper
from routes.program import program_bp
from routes.contact import contact_bp
from routes.webcomponents import webcomponents_bp


app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'

# Set default values if environment variables are not set
app.config['website_title'] = os.getenv('website_title', 'None')
app.config['navbar_title'] = os.getenv('navbar_title', 'None')
app.config['domain'] = os.getenv('domain', 'http://localhost')

app.register_blueprint(about_bp)
app.register_blueprint(registration_bp)
app.register_blueprint(acceptance_of_paper)
app.register_blueprint(program_bp)
app.register_blueprint(contact_bp)
app.register_blueprint(webcomponents_bp)


@app.errorhandler(404)
def page_not_found(e):
    components = components_service.get_all_components()
    return render_template('pages/404.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)

    

if __name__ == '__main__':
    
    app.run(debug=True)
