# from flask import Blueprint, render_template, current_app
# from services import schedule_service, imp_dates_service, components_service

# acceptance_of_paper = Blueprint("acceptance_of_paper", __name__)

# @acceptance_of_paper.route("/important-dates")
# def ImportantDates():
#     dates = imp_dates_service.get_imp_dates()
#     components = components_service.get_all_components()
#     navItems = components_service.get_navbar_items()
#     return render_template('screens/acceptance of paper/importantdates.html', dates=dates, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components, navItems=navItems)

# @acceptance_of_paper.route("/detailed-schedule")
# def DetailedSchedule():
#     schedules = schedule_service.get_schedule()
#     components = components_service.get_all_components()
#     navItems = components_service.get_navbar_items()
#     return render_template('screens/program/detailedschedule.html', schedules=schedules, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components, navItems=navItems)

# @acceptance_of_paper.route("/paper-status")
# def PaperStatus():
#     components = components_service.get_all_components()
#     navItems = components_service.get_navbar_items()
#     return render_template('screens/acceptance of paper/paperstatus.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components, navItems=navItems)