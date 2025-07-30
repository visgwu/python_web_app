from flask import Flask, render_template, request, redirect, url_for, flash, session
import os
from auth import verify_credentials

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Change this to a random secret key

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    
    if verify_credentials(username, password):
        session['username'] = username  # Store user in session
        return redirect(url_for('welcome', username=username))
    else:
        flash('Invalid username or password. Please try again.')
        return redirect(url_for('home'))

@app.route('/welcome/<username>')
def welcome(username):
    # Only allow access if user is logged in
    if session.get('username') != username:
        return redirect(url_for('home'))
    return render_template('welcome.html', username=username)

@app.route('/logout')
def logout():
    session.pop('username', None)
    flash('You have been logged out.')
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)