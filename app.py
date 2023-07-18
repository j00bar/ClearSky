from flask import Flask, render_template, request, session
import requests
import urllib.parse
from datetime import datetime
from waitress import serve
import logging.config
import configparser
import os
import sys
import uuid
import platform
# ======================================================================================================================
# ============================= Pre-checks // Set up logging and debugging information =================================
# Checks if .ini file exits locally and exits if it doesn't
if not os.path.exists('config.ini'):
    print("No Config file", "Config.ini file does not exist\nPlace config.ini in: " + str(os.getcwd()) + "\nRe-run program")
    sys.exit()

# Read log directory from .ini and if directory structure doesn't, exist create it.
config = configparser.ConfigParser()
config.read("config.ini")

# Check OS and assigns log location based on file OS file system
try:
    log_dir = None
    current_os = platform.platform()
    current_os = "linux"
    if "Windows" in current_os:
        log_dir = config.get("handler_fileHandler", "logdir")
    else:
        linux_args = config.get("linux", "args")
        log_dir = config.get("linux", "logdir")
        config.set("handler_fileHandler", "args", str(linux_args))
        with open('config.ini', 'w') as configfile:
            config.write(configfile)
            configfile.close()
except (configparser.NoOptionError, configparser.NoSectionError, configparser.MissingSectionHeaderError):
    sys.exit()
try:
    if os.path.exists(log_dir) is False:
        os.makedirs(log_dir)
except PermissionError:
    print("Cannot create log directory\nChange 'agrs' and 'logdir' in config.ini path to a path with permissions")
    sys.exit()

logging.config.fileConfig('config.ini')
logger = logging.getLogger()

title_name = "ClearSky"
os.system("title " + title_name)
version = "0.0.3"
current_dir = os.getcwd()
log_version = "ClearSky Version: " + version
runtime = datetime.now()
current_time = runtime.strftime("%m%d%Y::%H:%M:%S")
try:
    username = os.getlogin()
except OSError:
    username = "Cannot get username"
    pass
logger.info(log_version)
logger.debug("Ran from: " + current_dir)
logger.debug("Ran by: " + username)
logger.debug("Ran at: " + str(current_time))

app = Flask(__name__)

# Configure session secret key
app.secret_key = 'your-secret-key'


# ======================================================================================================================
# ================================================== HTML Pages ========================================================
@app.route('/')
def index():
    # Generate a new session number and store it in the session
    if 'session_number' not in session:
        session['session_number'] = generate_session_number()
    return render_template('index.html')


@app.route('/status')
def always_200():

    return "OK", 200


@app.route('/contact')
def contact():

    return render_template('contact.html')


# Handles selection for form
@app.route('/selection_handle', methods=['POST'])
def selection_handle():
    global session_ip
    session_ip = get_ip()
    identifier = request.form['identifier'].lower()
    identifier = identifier.replace('@', '')
    selection = request.form['selection']
    if selection == "1":
        logger.info(str(session_ip) + " > " + str(*session.values()) + ": " + "DID resolve request made for: " + identifier)
        result = resolve_handle(identifier)
        logger.info(str(session_ip) + " > " + str(*session.values()) + " | " + "Request Result: " + identifier + " | " + result)

        return render_template('result.html', result=result)
    elif selection == "2":
        logger.info(str(session_ip) + " > " + str(*session.values()) + " | " + "Handle resolve request made for: " + identifier)
        result = resolve_did(identifier)
        logger.info(str(session_ip) + " > " + str(*session.values()) + " | " + "Request Result: " + identifier + " | " + str(result))

        return render_template('result.html', result=result)
    elif selection == "3":
        logger.info(str(session_ip) + " > " + str(*session.values()) + " | " + "Block list requested for: " + identifier)
        blocklist, count = get_user_block_list_html(identifier)

        return render_template('blocklist.html', block_list=blocklist, user=identifier, count=count)


@app.route('/blocklist')
def get_user_block_list_html(ident):
    blocked_users, timestamps = get_user_block_list(ident)
    handles = []
    if blocked_users:
        for handle in process_did_list_to_handle(blocked_users):
            handles.append(handle)
    else:
        handles = [f"{ident} hasn't blocked anyone."]

    total_blocked = len(handles)
    logger.info(str(session_ip) + " > " + str(*session.values()) + " | " + "Blocklist Request Result: " + ident + " | " + str(list(zip(handles, timestamps))))

    return zip(handles, timestamps), total_blocked


# ======================================================================================================================
# ======================================================= Logic ========================================================
def generate_session_number():

    return str(uuid.uuid4().hex)


def get_ip():  # Get IP address of session request
    if 'X-Forwarded-For' in request.headers:
        # Get the client's IP address from the X-Forwarded-For header
        ip = request.headers['X-Forwarded-For']
        # The client's IP address may contain multiple comma-separated values
        # Extract the first IP address from the list
        ip = ip.split(',')[0].strip()
    else:
        # Use the remote address if the X-Forwarded-For header is not available
        ip = request.remote_addr
    return ip


def resolve_handle(info):  # Take Handle and get DID
    base_url = "https://bsky.social/xrpc/"
    url = urllib.parse.urljoin(base_url, "com.atproto.identity.resolveHandle")
    params = {
        "handle": info
    }

    encoded_params = urllib.parse.urlencode(params, quote_via=urllib.parse.quote)
    full_url = f"{url}?{encoded_params}"
    logger.debug(full_url)
    get_response = requests.get(full_url)
    response = get_response.json().values()

    return list(response)[0]


def resolve_did(did):  # Take DID and get handle
    handle = did
    base_url = "https://bsky.social/xrpc/"
    url = urllib.parse.urljoin(base_url, "com.atproto.repo.describeRepo")
    params = {
        "repo": handle
    }

    encoded_params = urllib.parse.urlencode(params, quote_via=urllib.parse.quote)
    full_url = f"{url}?{encoded_params}"
    logger.debug(full_url)
    get_response = requests.get(full_url)

    if get_response.status_code == 200:
        response_json = get_response.json()
        records = response_json["handle"]

        return records
    else:
        print("Error:", get_response.status_code)


def get_user_block_list(ident):
    base_url = "https://bsky.social/xrpc/"
    collection = "app.bsky.graph.block"
    limit = 100
    blocked_users = []
    created_dates = []
    cursor = None

    while True:
        url = urllib.parse.urljoin(base_url, "com.atproto.repo.listRecords")
        params = {
            "repo": ident,
            "limit": limit,
            "collection": collection,
            "cursor": cursor
        }

        if cursor:
            params["cursor"] = cursor

        encoded_params = urllib.parse.urlencode(params, quote_via=urllib.parse.quote)
        full_url = f"{url}?{encoded_params}"
        logger.debug(full_url)
        response = requests.get(full_url)

        if response.status_code == 200:
            response_json = response.json()
            records = response_json.get("records", [])

            for record in records:
                value = record.get("value", {})
                subject = value.get("subject")
                created_at_value = value.get("createdAt")
                if subject:
                    blocked_users.append(subject)
                if created_at_value:
                    created_date = datetime.strptime(created_at_value, "%Y-%m-%dT%H:%M:%S.%fZ").date()
                    created_dates.append(created_date)

            cursor = response_json.get("cursor")
            if not cursor:
                break

    # cursor = response_json.get("cursor")
    if not blocked_users:
        return [], [str(datetime.now().date())]

    # Return the blocked users and created_at timestamps if needed
    return blocked_users, created_dates


def process_did_list_to_handle(did_list):
    handle_list = []
    for item in did_list:
        handle_list.append(resolve_did(item))

    return handle_list


ip_address = config.get("server", "ip")
port_address = config.get("server", "port")

if __name__ == '__main__':
    logger.info("Web server starting at: " + ip_address + ":" + port_address)
    serve(app, host=ip_address, port=port_address)
