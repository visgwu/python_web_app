# Python Web Application

A production-ready, minimal Flask web application featuring secure user authentication, modular structure, and CI/CD integration.

---

## Features

- **User Authentication:** Secure login with credentials stored in a local file.
- **Session Management:** User sessions with login/logout support.
- **Responsive UI:** Clean, modern login and welcome pages.
- **CI/CD:** Automated build and artifact packaging with GitHub Actions.
- **Easy Deployment:** Ready for deployment to platforms like Heroku, Render, or Azure.

---

## Project Structure

```
python-web-app/
├── src/
│   ├── app.py                # Main Flask application
│   ├── auth.py               # Authentication logic
│   ├── credentials.txt       # Username:password pairs (for demo only)
│   ├── templates/
│   │   ├── login.html        # Login page template
│   │   └── welcome.html      # Welcome page template
│   └── static/
│       └── style.css         # CSS styles
├── requirements.txt          # Python dependencies
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions workflow
└── README.md                 # Project documentation
```

---

## Getting Started

### 1. Clone the Repository

```sh
git clone https://github.com/<your-username>/python-web-app.git
cd python-web-app
```

### 2. Install Dependencies

Ensure you have Python 3.8+ and pip installed.

```sh
pip install -r requirements.txt
```

### 3. Configure Credentials

Edit `src/credentials.txt` to add your username and password pairs (format: `username:password`), one per line.

> **Note:** For production, use a secure database and hashed passwords.

### 4. Run the Application

```sh
python src/app.py
```

The app will be available at [http://127.0.0.1:5000](http://127.0.0.1:5000).

---

## Usage

- **Login:** Use credentials from `src/credentials.txt`.
- **Logout:** Click the logout button on the welcome page to end your session.

---

## CI/CD Pipeline

This project uses [GitHub Actions](https://github.com/features/actions) for automated testing and artifact packaging.

- **Workflow file:** `.github/workflows/ci.yml`
- **Build artifacts:** On every tagged release (e.g., `v1.0.0`), a zip archive of the app is attached to the GitHub Release.

### Triggering a Release

```sh
git tag v1.0.0
git push origin v1.0.0
```

Artifacts will appear on the [Releases](../../releases) page.

---

## Deployment

You can deploy this app to any cloud platform that supports Python/Flask, such as:

- [Heroku](https://heroku.com/)
- [Render](https://render.com/)
- [Azure App Service](https://azure.microsoft.com/en-us/products/app-service/)
- [Railway](https://railway.app/)

**For Heroku:**

1. Add a `Procfile` with:
   ```
   web: python src/app.py
   ```
2. Push to Heroku following their [Python deployment guide](https://devcenter.heroku.com/articles/getting-started-with-python).

---

## Security Notice

- **Do not use plain text credentials in production.**
- Use environment variables, hashed passwords, and a secure database for real-world deployments.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## Contact

For questions or support, open an issue on GitHub.