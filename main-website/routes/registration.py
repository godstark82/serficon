from flask import Blueprint, render_template, current_app
from services import components_service
registration_bp = Blueprint("registration", __name__)

@registration_bp.route("/registration")
def Registration():
    navItems = components_service.get_navbar_items()
    components = components_service.get_all_components()
    
    return render_template('pages/registration.html', components=components, navItems=navItems)