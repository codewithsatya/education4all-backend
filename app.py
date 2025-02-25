from flask import Flask, request
from markupsafe import escape

app = Flask(__name__)






# @app.route("/")
# def hello_world():
#     return "<p>Hello, World!</p>"


# @app.route("/<name>")
# def hello_wordd(name):
#     print(name,"checking name")
#     return f"<h1>Hello, {escape(name)}!</h1>"




# @app.route("/user/<username>")
# def show_user_profile(username):
#     return f"<h2>User {escape(username)}</h2>"

# @app.route("/users")
# def getUsers():
#     return "List of users"



# @app.route("/tutor/<int:tutor_id>")
# def getTutorById(tutor_id):
#     # show the tutor with the given id, the id is an integer
#     return f"Tutor ID: {tutor_id}"


# @app.route('/projects/')
# def projects():
#     return 'The project page'


# @app.route('/about')
# def about():
#     return 'The about page'

# @app.route('/path/<path:subpath>')
# def show_subpath(subpath):
#     # show the subpath after /path/
#     return f'Subpath {escape(subpath)}'


# @app.route('/login',methods=['GET','POST'])
# def login():
#     if request.method == 'GET':
#         return do_the_login()
#     else: 
#         return show_the_login_form()

# def show_the_login_form():
#     return "This is the login form"

# def do_the_login():
#     return "Logging in..."