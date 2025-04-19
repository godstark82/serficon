import datetime
from flask import Flask, render_template, send_from_directory, request, redirect, url_for, flash
from services import components_service, page_service, imp_dates_service, schedule_service, reward_service, home_service
from routes.paper_upload import paper_upload_bp
from routes.contact import contact_bp
from routes.home import webcomponents_bp
from models.components_model import ComponentsModel

app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'


app.register_blueprint(paper_upload_bp)
app.register_blueprint(contact_bp)
app.register_blueprint(webcomponents_bp)


@app.errorhandler(404)
def page_not_found(e):
    sections = home_service.get_home_data()
    navItems = components_service.get_navbar_items()    
    components = components_service.get_all_components()
    return render_template('pages/404.html', components=components, sections=sections, navItems=navItems)


# static files
@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory(app.static_folder, filename)

# robots.txt
@app.route('/robots.txt')
def robots_txt():
    components: ComponentsModel = components_service.get_all_components()
    robots_content = f"""User-agent: *
Allow: /
Disallow: /admin/   
Sitemap: https://www.{components.domain}/sitemap.xml
"""
    return robots_content, 200, {'Content-Type': 'text/plain'}

# sitemap.xml
@app.route('/sitemap.xml')
def sitemap_xml():
    components: ComponentsModel = components_service.get_all_components()
    navItems = components_service.get_navbar_items()
    
    # Start the sitemap XML
    sitemap_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://www.{components.domain}/</loc>
        <priority>1.0</priority>
    </url>
"""
    
    # Add all navigation items to the sitemap
    for nav_item in navItems:
        if nav_item.path:
            sitemap_content += f"""    <url>
        <loc>https://www.{components.domain}{nav_item.path}</loc>
        <priority>0.8</priority>
    </url>
"""
        # Add child pages
        for child in nav_item.children:
            if child.path:
                sitemap_content += f"""    <url>
        <loc>https://www.{components.domain}{child.path}</loc>
        <priority>0.7</priority>
    </url>
"""
    
    # Close the sitemap
    sitemap_content += "</urlset>"
    
    return sitemap_content, 200, {'Content-Type': 'application/xml'}



@app.route('/<path>/<subpath>/<id>')
def page_route(path, subpath, id):
    page_content = page_service.get_page_content(id)
    components = components_service.get_all_components()
    navItems = components_service.get_navbar_items()
    if path == "program" and ("important-dates" in subpath):
        dates = imp_dates_service.get_imp_dates()
        return render_template('pages/important-dates.html', page=page_content, components=components, navItems=navItems, dates=dates)
    elif path == "program" and ("schedule" in subpath):
        schedules = schedule_service.get_schedule()
        return render_template('pages/detailed-schedule.html', page=page_content, components=components, navItems=navItems, schedules=schedules)
    elif path == "program" and ("wards" in subpath):
        rewards = reward_service.get_rewards_grants()
        return render_template('pages/awards-and-grants.html', page=page_content, components=components, navItems=navItems, rewards=rewards)
    return render_template('page_template.html', page=page_content, components=components, navItems=navItems)


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    components = components_service.get_all_components()
    navItems = components_service.get_navbar_items()
    
    if request.method == 'POST':
        email = request.form.get('email')
        
        # Check if the email is already registered
        from db_instance import db
        
        # Query the registrations collection for the email
        registration_ref = db.collection('registrations').where('email', '==', email).limit(1)
        registration_docs = registration_ref.stream()
        
        # Check if any documents match the query
        if any(registration_docs):
            flash('You are already registered with this email!', 'warning')
        else:
            # Create a new registration document
            registration_data = {
                'email': email,
                'name': request.form.get('name'),
                'affiliation': request.form.get('affiliation'),
                'category': request.form.get('participant_category'),
                'days': request.form.get('days_attending'),
                'presenting_paper': request.form.get('are_you_presenting'),
                'country': request.form.get('country'),
                'phone': request.form.get('phone'),
                'registration_date': datetime.datetime.now().isoformat()
            }
            
            # Add the document to the registrations collection
            db.collection('registrations').add(registration_data)
            
            flash('Registration submitted successfully!', 'success')
        
        return redirect(url_for('registration'))
    
    return render_template('pages/registration.html', components=components, navItems=navItems)


if __name__ == '__main__':
    app.run(debug=True)
