from flask import Blueprint

carrier_funnel = Blueprint('carrier_funnel', __name__)

# Carrier Funnel Routes
@carrier_funnel.route('/carrier/available-orders/<schoolId>', methods=['GET'])
def get_available_orders(schoolId):
    # Returns all orders for school
    pass

@carrier_funnel.route('/carrier/claim/<carrierId>/<orderId>', methods=['POST'])
def claim_order(carrierId, orderId):
    # Claims order for carrier
    pass

@carrier_funnel.route('/confirm-order-retrieval/<orderId>', methods=['POST'])
def confirm_retrieval(orderId):
    # Confirms order was retrieved
    pass