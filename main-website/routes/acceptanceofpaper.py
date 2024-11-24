from flask import Blueprint, render_template, current_app
from services import page_service, imp_dates_service, components_service

acceptance_of_paper = Blueprint("acceptance_of_paper", __name__)

@acceptance_of_paper.route("/important-dates")
def ImportantDates():
    dates = imp_dates_service.get_imp_dates()
    components = components_service.get_all_components()
    return render_template('screens/acceptance of paper/importantdates.html', dates=dates, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)

@acceptance_of_paper.route("/review-process")
def ReviewProcess():
    page = page_service.get_page_content('review_process')
    components = components_service.get_all_components()
    return render_template('screens/acceptance of paper/reviewprocess.html', page=page, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)

@acceptance_of_paper.route("/submission-guidelines")
def SubmissionGuidelines():
    page = page_service.get_page_content('submission_guidelines')
    components = components_service.get_all_components()
    return render_template('screens/acceptance of paper/subgl.html', page=page, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)

@acceptance_of_paper.route("/paper-status")
def PaperStatus():
    components = components_service.get_all_components()
    return render_template('screens/acceptance of paper/paperstatus.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'], components=components)