from flask import Flask, render_template, request, flash, redirect, url_for
from db_instance import get_db
from models.committee_model import CommitteeRole
from services import committee_service, faq_service, home_service, imp_dates_service, mail_service, schedule_service

app = Flask(__name__)
app.secret_key = 'conference_2024secretkey'


@app.route("/")
def Home():
    home = home_service.get_home_data()
    return render_template('index.html', home=home)

@app.route("/organizing-committee")
def OrganizingCommittee():
    title = "Organizing Committee"
    members = committee_service.get_all_committee_members()
    members = [member for member in members if member.role == CommitteeRole.ORGANISING_COMMITTEE.value]
    return render_template('screens/about/oc.html', title=title, members=members)

@app.route("/scientific-committee")
def ScientificCommittee():
    title = "Scientific Committee"
    members = committee_service.get_all_committee_members()
    members = [member for member in members if member.role == CommitteeRole.SCIENTIFIC_COMMITTEE_MEMBER.value]
    return render_template('screens/about/oc.html', title=title, members=members)



@app.route("/registration")
def Registration():
    return render_template('registration.html')

@app.route("/important-dates")
def ImportantDates():
    dates = imp_dates_service.get_imp_dates()
    return render_template('screens/Guide for authors/importantdates.html', dates=dates)

@app.route("/review-process")
def ReviewProcess():
    review_process = faq_service.get_review_process()
    return render_template('screens/Guide for authors/reviewprocess.html', review_process=review_process)

@app.route("/submission-guidelines")
def SubmissionGuidelines():
    submission_guidelines = faq_service.get_submission_guidelines()
    return render_template('screens/Guide for authors/subgl.html', guidelines=submission_guidelines)

@app.route("/paper-status")
def PaperStatus():
    return render_template('screens/Guide for authors/paperstatus.html')

@app.route("/detailed-schedule")
def DetailedSchedule():
    schedules = schedule_service.get_schedule()
    return render_template('screens/program/detailedschedule.html', schedules=schedules)

@app.route("/awards-grants")
def AwardsAndGrants():
    rewards = faq_service.get_rewards_grants()
    return render_template('screens/program/awardsngrants.html', rewards=rewards)

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

    return render_template('contact.html')

# @app.route("/social-links")
# def SocialLinks():
    # return sociallink_service.get_social_links()

if __name__ == '__main__':
    app.run(debug=True)
