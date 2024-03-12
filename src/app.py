# archivo para crear un servidor web con flask

from flask import Flask, render_template

from config import config

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('auth/InicioSesión.html')


if __name__ == '__main__':
    app.config.from_object(config['development'])
    app.run()





#@app.route("/")
#def home():
#    return "Hello, World!!!"


#@app.route('/new')
#def add_contact():
#    return "Add contact"
