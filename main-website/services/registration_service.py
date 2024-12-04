from typing import List
import mimetypes
from flask import request

def get_registration_data():
    # Get form data from request
    title = request.form.get('title')
    name = request.form.get('name')
    email = request.form.get('email')
    article_title = request.form.get('article_title')
    document_type = request.form.get('document_type')
    affiliation = request.form.get('affiliation')
    abstract = request.form.get('abstract')
    keywords = request.form.get('keywords')
    topic_type = request.form.get('topic_type')
    
    # Handle PDF file upload
    pdf_file = request.files.get('pdf_file')
    
    # Handle authors data (assuming it's sent as JSON)
    authors = request.form.getlist('authors[]')
    
    # TODO: Validate the data
    
    return {
        "title": title,
        "name": name,
        "email": email,
        "article_title": article_title,
        "document_type": document_type,
        "affiliation": affiliation,
        "abstract": abstract,
        "keywords": keywords,
        "topic_type": topic_type,
        "pdf_file": pdf_file,
        "authors": authors
    }
    

