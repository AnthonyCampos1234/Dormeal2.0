from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from routes.carrier_funnel import carrier_funnel
from routes.order_funnel import order_funnel
from routes.session_management import session_management

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your-secret-key-here'  # Required for session management
app.config['SQLALCHEMY_USER'] = 'verified_user'  # Database user with restricted permissions
app.config['SQLALCHEMY_PASSWORD'] = 'strong_password'  # Database user password
db = SQLAlchemy(app)

app.register_blueprint(carrier_funnel)
app.register_blueprint(order_funnel)
app.register_blueprint(session_management)

if __name__ == '__main__':
    app.run(debug=True)

