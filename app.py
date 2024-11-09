from flask import Flask
from routes.carrier_funnel import carrier_funnel
from routes.order_funnel import order_funnel
from routes.session_management import session_management

app = Flask(__name__)

app.register_blueprint(carrier_funnel)
app.register_blueprint(order_funnel)
app.register_blueprint(session_management)