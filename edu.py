# app.py
from flask import Flask, render_template, request, redirect, url_for # type: ignore
from database import db, Resource

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///resources.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()

@app.route('/')
def index():
    resources = Resource.query.all()
    return render_template('index.html', resources=resources)

@app.route('/add', methods=['GET', 'POST'])
def add_resource():
    if request.method == 'POST':
        title = request.form['title']
        resource_type = request.form['resource_type']
        url = request.form['url']
        new_resource = Resource(title=title, resource_type=resource_type, url=url)
        db.session.add(new_resource)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('add_resource.html')

@app.route('/delete/<int:resource_id>')
def delete_resource(resource_id):
    resource = Resource.query.get_or_404(resource_id)
    db.session.delete(resource)
    db.session.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)

    