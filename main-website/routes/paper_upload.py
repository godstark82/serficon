from flask import request
from flask import Blueprint, render_template, flash, redirect, url_for
from services import components_service, registration_service

paper_upload_bp = Blueprint("paper_upload", __name__)

@paper_upload_bp.route("/paper-upload", methods=['GET','POST']) 
def paper_upload():
    if request.method == 'POST':
        # Process the form data
        form_data = registration_service.get_registration_data()
        registration_service.upload_article_to_db(form_data)
        flash("Data has been sent") 
        return redirect(url_for('paper_upload.paper_upload'))

    navItems = components_service.get_navbar_items()
    components = components_service.get_all_components()
    return render_template('pages/paper-upload.html', components=components, navItems=navItems)