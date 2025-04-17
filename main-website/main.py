from flask import Flask, render_template, send_from_directory
from services import components_service, page_service, imp_dates_service, schedule_service, reward_service, home_service
from routes.registration import registration_bp
from routes.contact import contact_bp
from routes.home import webcomponents_bp
from models.components_model import ComponentsModel

app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'


app.register_blueprint(registration_bp)
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


if __name__ == '__main__':
    app.run(debug=True)
