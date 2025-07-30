import os

CREDENTIALS_FILE = os.path.join(os.path.dirname(__file__), 'credentials.txt')

def load_credentials():
    creds = {}
    try:
        with open(CREDENTIALS_FILE, 'r') as f:
            for line in f:
                if ':' in line:
                    username, password = line.strip().split(':', 1)
                    creds[username] = password
    except Exception as e:
        print(f"Error loading credentials: {e}")
    return creds

def verify_credentials(username, password):
    credentials = load_credentials()
    return credentials.get(username) == password