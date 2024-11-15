import os
from flask import Flask, render_template, request, flash, redirect, url_for
from db_instance import get_db
from services import faq_service, home_service, imp_dates_service, mail_service, page_service, schedule_service

app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'
website_title = os.getenv('website_title')
navbar_title = os.getenv('navbar_title')
domain = os.getenv('domain')

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html', website_title=website_title, navbar_title=navbar_title, domain=domain), 404

@app.route("/")
def Home():
    home = home_service.get_home_data()
    return render_template('index.html', home=home, website_title=website_title, navbar_title=navbar_title, domain=domain)


@app.route("/organizing-committee")
def OrganizingCommittee():
    title = "Organizing Committee"
    page = page_service.get_page_content('organizing-committee')
    return render_template('screens/about/committee.html', title=title, page=page, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/scientific-committee")
def ScientificCommittee():
    title = "Scientific Committee"
    page = page_service.get_page_content('scientific-committee-member')
    return render_template('screens/about/committee.html', title=title, page=page, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/scientific-lead")
def ScientificLead():
    title = "Scientific Lead"
    page = page_service.get_page_content('scientific-lead')
    return render_template('screens/about/committee.html', title=title, page=page, website_title=website_title, navbar_title=navbar_title, domain=domain)



@app.route("/registration")
def Registration():
    return render_template('registration.html', website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/important-dates")
def ImportantDates():
    dates = imp_dates_service.get_imp_dates()
    return render_template('screens/Guide for authors/importantdates.html', dates=dates, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/review-process")
def ReviewProcess():
    review_process = faq_service.get_review_process()
    return render_template('screens/Guide for authors/reviewprocess.html', review_process=review_process, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/submission-guidelines")
def SubmissionGuidelines():
    submission_guidelines = faq_service.get_submission_guidelines()
    return render_template('screens/Guide for authors/subgl.html', guidelines=submission_guidelines, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/paper-status")
def PaperStatus():
    return render_template('screens/Guide for authors/paperstatus.html', website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/detailed-schedule")
def DetailedSchedule():
    schedules = schedule_service.get_schedule()
    return render_template('screens/program/detailedschedule.html', schedules=schedules, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/awards-grants")
def AwardsAndGrants():
    rewards = faq_service.get_rewards_grants()
    return render_template('screens/program/awardsngrants.html', rewards=rewards, website_title=website_title, navbar_title=navbar_title, domain=domain)

@app.route("/contact", methods=['GET', 'POST'])
def Contact():
    if request.method == 'POST':
        
        name = request.form.get("name", "")
        email = request.form.get("email", "")
        subject = request.form.get("subject", "")
        message = request.form.get("message", "")

        if not all([name, email, subject, message]):
            flash("Please fill in all fields", "error")
            return redirect(url_for('Contact'))

        mail_service.send_email(name, email, subject, message)
        flash("Message sent successfully", "success")
        return redirect(url_for('Contact')) 

    return render_template('contact.html', website_title=website_title, navbar_title=navbar_title, domain=domain)

# @app.route("/social-links")
# def SocialLinks():
    # return sociallink_service.get_social_links()

if __name__ == '__main__':
    app.run(debug=True)
