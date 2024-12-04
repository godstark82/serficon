from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def send_email():
    password = "uawa sqfi fwlr wggp"  # Replace with your Gmail password or app-specific password
    msg = MIMEMultipart()
    msg['Subject'] = f"New Contact Form Submission: {subject}"

    body = f"""
    You have received a new message from the contact form.

    Full Name: {name}
    Email: {email}
    Subject: {subject}

    Message:
    {message}
    """

    msg.attach(MIMEText(body, 'plain'))

    # Send the email via Gmail's SMTP server
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, password)
        text = msg.as_string()
        server.sendmail(sender_email, receiver_email, text)
        server.quit()
    except Exception as e:
        print(f"Failed to send email. Error: {e}")

