from flask import Blueprint, render_template
from services import page_service, components_service

about_bp = Blueprint("conferences", __name__)

def render_committee_page(page_key, title):
    page = page_service.get_page_content(page_key)
    components = components_service.get_all_components()
    return render_template('screens/about/committee.html', title=title, page=page,
                           components=components
                           )    

@about_bp.route("/conference-chair")
def ConferenceChair():
    return render_committee_page('organising-committee', "Conference Chair")

@about_bp.route("/organizing-committee")
def OrganizingCommittee():
    return render_committee_page('scientific-committee-member', "Organizing Committee")

@about_bp.route("/technical-committee")
def TechnicalCommittee():
    return render_committee_page('scientific-lead', "Technical Committee")
