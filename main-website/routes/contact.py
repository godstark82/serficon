from flask import Blueprint, render_template, current_app, request, flash, redirect, url_for
from services import mail_service, components_service

contact_bp = Blueprint("contact", __name__)

@contact_bp.route("/contact", methods=['GET', 'POST'])
def Contact():
    if request.method == 'POST':
        name = request.form.get("name", "")
        email = request.form.get("email", "")
        subject = request.form.get("subject", "")
        message = request.form.get("message", "")

        if not all([name, email, subject, message]):
            flash("Please fill in all fields", "error")
            return redirect(url_for('contact.contact'))

        mail_service.send_email(name, email, subject, message)
        flash("Message sent successfully", "success")
        return redirect(url_for('contact.contact')) 

    components = components_service.get_all_components()
    return render_template('pages/contact.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)