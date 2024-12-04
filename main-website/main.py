from flask import Flask, jsonify, render_template, request

from services import components_service, page_service, imp_dates_service, schedule_service, reward_service
from routes.registration import registration_bp
from routes.contact import contact_bp
from routes.home import webcomponents_bp
from services.registration_service import get_registration_data


app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'


app.register_blueprint(registration_bp)
app.register_blueprint(contact_bp)
app.register_blueprint(webcomponents_bp)


@app.errorhandler(404)
def page_not_found(e):
    components = components_service.get_all_components()
    return render_template('pages/404.html', components=components)


@app.route('/register', methods=['POST'])
def register():
    data = get_registration_data()
    
    # Save the file if needed
    pdf_file = request.files.get('pdf_file')
    if pdf_file:
        # Add your file saving logic here
        # For example:
        # pdf_file.save('path/to/save/' + pdf_file.filename)
        pass
    
    return jsonify({"message": "Registration received", "data": data})

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
