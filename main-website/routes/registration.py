from flask import Blueprint, render_template, current_app
from services import components_service
registration_bp = Blueprint("registration", __name__)

@registration_bp.route("/registration")
def Registration():
    components = components_service.get_all_components()
    return render_template('pages/registration.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)