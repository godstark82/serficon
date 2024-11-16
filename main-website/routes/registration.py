from flask import Blueprint, render_template, current_app
registration_bp = Blueprint("registration", __name__)

@registration_bp.route("/registration")
def Registration():
    return render_template('pages/registration.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'])