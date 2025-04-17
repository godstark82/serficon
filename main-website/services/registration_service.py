import os
from flask import request
from firebase_admin import storage
from datetime import datetime
from db_instance import db
from models.article_model import ArticleModel, ArticleStatus, AuthorModel



def upload_to_firebase(file):
    try:
        # Create a unique filename
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"papers/{timestamp}_{file.filename}"
        
        # Get bucket
        bucket = storage.bucket(name=os.getenv("STORAGE_BUCKET"))
        
        # Create blob and upload the file
        blob = bucket.blob(filename)
        blob.upload_from_string(
            file.read(),
            content_type=file.content_type
        )
        
        # Make the blob publicly accessible (optional)
        blob.make_public()
        
        # Return the public URL
        return blob.public_url
    except Exception as e:
        print(f"Error uploading to Firebase: {str(e)}")
        return None

def get_registration_data():
    # Get basic form data
    form_data = {
        "title": request.form.get('title'),
        "name": request.form.get('name'),
        "email": request.form.get('email'),
        "article_title": request.form.get('article_title'),
        "document_type": request.form.get('document_type'),
        "affiliation": request.form.get('affiliation'),
        "abstract": request.form.get('abstract'),
        "keywords": request.form.get('keywords'),
        "topic_type": request.form.get('topic_type'),
        "paper_type": request.form.getlist('paper_type[]'),
        "status": "pending",
        "created_at": datetime.now().isoformat()
    }
    
    # Handle PDF file
    pdf_file = request.files.get('pdf_file')
    if pdf_file:
        # Upload to Firebase and get URL
        pdf_url = upload_to_firebase(pdf_file)
        form_data["pdf_url"] = pdf_url
    else:
        form_data["pdf_url"] = None
    
    # Handle additional authors
    additional_authors = []
    author_names = request.form.getlist('additional_authors[name][]')
    author_affiliations = request.form.getlist('additional_authors[affiliation][]')
    author_emails = request.form.getlist('additional_authors[email][]')
    author_corresponding = request.form.getlist('additional_authors[corresponding][]')
    
    for i in range(len(author_names)):
        if author_names[i]:  # Only add if name is not empty
            author = {
                "name": author_names[i],
                "affiliation": author_affiliations[i] if i < len(author_affiliations) else "",
                "email": author_emails[i] if i < len(author_emails) else "",
                "is_corresponding": i < len(author_corresponding)
            }
            additional_authors.append(author)
    
    form_data["additional_authors"] = additional_authors
    


    
    return form_data
    

def upload_article_to_db(data:dict):
    doc_ref = db.collection("articles").document()
    data["id"] = doc_ref.id
    doc_ref.set(data)
