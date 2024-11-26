from flask import Blueprint, render_template, current_app
from services import home_service, components_service

webcomponents_bp = Blueprint("webcomponents", __name__)
@webcomponents_bp.route("/")
def WebComponents():
    sections = home_service.get_home_data()
    components = components_service.get_all_components()
    print(sections[0])
    return render_template('index.html', sections=sections, domain=current_app.config['domain'], components=components)