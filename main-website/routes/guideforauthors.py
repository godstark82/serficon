from flask import Blueprint, render_template, current_app
from services import faq_service, imp_dates_service

guide_for_authors_bp = Blueprint("guide_for_authors", __name__)

@guide_for_authors_bp.route("/important-dates")
def ImportantDates():
    dates = imp_dates_service.get_imp_dates()
    return render_template('screens/Guide for authors/importantdates.html', dates=dates, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'])

@guide_for_authors_bp.route("/review-process")
def ReviewProcess():
    review_process = faq_service.get_review_process()
    return render_template('screens/Guide for authors/reviewprocess.html', review_process=review_process, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'])

@guide_for_authors_bp.route("/submission-guidelines")
def SubmissionGuidelines():
    submission_guidelines = faq_service.get_submission_guidelines()
    return render_template('screens/Guide for authors/subgl.html', guidelines=submission_guidelines, website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'])

@guide_for_authors_bp.route("/paper-status")
def PaperStatus():
    return render_template('screens/Guide for authors/paperstatus.html', website_title=current_app.config['website_title'], navbar_title=current_app.config['navbar_title'], domain=current_app.config['domain'])