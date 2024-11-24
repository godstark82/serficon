from flask import Blueprint, render_template, current_app
from services import page_service, components_service

about_bp = Blueprint("conferences", __name__)

def render_committee_page(page_key, title):
    page = page_service.get_page_content(page_key)
    components = components_service.get_all_components()
    return render_template('screens/about/committee.html', title=title, page=page, 
                           website_title=current_app.config['website_title'], 
                           navbar_title=current_app.config['navbar_title'], 
                           domain=current_app.config['domain'], 
                           components=components)

@about_bp.route("/conference-chair")
def ConferenceChair():
    return render_committee_page('conference-chair', "Conference Chair")

@about_bp.route("/organizing-committee")
def OrganizingCommittee():
    return render_committee_page('organizing-committee', "Organizing Committee")

@about_bp.route("/technical-committee")
def TechnicalCommittee():
    return render_committee_page('technical-committee-member', "Technical Committee")
