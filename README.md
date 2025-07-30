# Python Web Application

This project is a simple web application built using Flask that includes user authentication with a login screen. It stores user credentials in a local file and verifies them upon login, displaying a welcome page for authenticated users.

## Project Structure

```
python-web-app
├── src
│   ├── app.py                # Entry point of the application
│   ├── auth.py               # User authentication functions
│   ├── credentials.txt       # Stores username and password pairs
│   ├── templates
│   │   ├── login.html        # HTML template for the login page
│   │   └── welcome.html      # HTML template for the welcome page
│   └── static
│       └── style.css         # CSS styles for the application
├── requirements.txt          # Project dependencies
├── .github
│   └── workflows
│       └── ci.yml            # CI/CD pipeline configuration
└── README.md                 # Project documentation
```

## Setup Instructions

1. **Clone the repository:**
   ```
   git clone <repository-url>
   cd python-web-app
   ```

2. **Install dependencies:**
   Ensure you have Python and pip installed, then run:
   ```
   pip install -r requirements.txt
   ```

3. **Run the application:**
   Start the Flask application by executing:
   ```
   python src/app.py
   ```

4. **Access the application:**
   Open your web browser and navigate to `http://127.0.0.1:5000` to view the login page.

## Usage Guidelines

- To log in, enter a username and password that matches the credentials stored in `src/credentials.txt`.
- Upon successful login, you will be redirected to the welcome page.

## CI/CD Pipeline

This project is set up with GitHub Actions for continuous integration and deployment. The configuration file is located at `.github/workflows/ci.yml`. Ensure that your tests are defined to take advantage of this setup.