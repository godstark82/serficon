from flask import request
from flask import Blueprint, render_template, flash, redirect, url_for
from services import components_service, registration_service

registration_bp = Blueprint("registration", __name__)

@registration_bp.route("/registration", methods=['GET','POST']) 
def Registration():
    if request.method == 'POST':
        # Process the form data
        form_data = registration_service.get_registration_data()
        registration_service.upload_article_to_db(form_data)
        flash("Data has been sent") 
        return redirect(url_for('registration.Registration'))

    navItems = components_service.get_navbar_items()
    components = components_service.get_all_components()
    return render_template('pages/registration.html', components=components, navItems=navItems)