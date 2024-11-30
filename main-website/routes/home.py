from flask import Blueprint, render_template
from services import home_service, components_service

webcomponents_bp = Blueprint("webcomponents", __name__)
@webcomponents_bp.route("/")
def WebComponents():
    sections = home_service.get_home_data()
    components = components_service.get_all_components()
    navItems = components_service.get_navbar_items()
    print(navItems)
    return render_template('index.html', sections=sections, components=components, navItems=navItems)

