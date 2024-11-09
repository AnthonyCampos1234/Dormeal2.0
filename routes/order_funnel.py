from flask import Blueprint

order_funnel = Blueprint('order_funnel', __name__)

# Order Funnel Routes (Consumer)
@order_funnel.route('/guest-school-selection', methods=['GET'])
def school_selection():
    # Return available schools
    pass

@order_funnel.route('/menu/<schoolId>/<restaurantMenuId>', methods=['GET'])
def get_menu(schoolId, restaurantMenuId):
    # Returns restaurant menu json
    pass

@order_funnel.route('/restaurant-menu/<schoolId>', methods=['GET'])
def get_restaurant_menu(schoolId):
    # Returns restaurant data json for school
    pass

@order_funnel.route('/order-status/<orderId>', methods=['GET'])
def get_order_status(orderId):
    # Gets order status
    pass

@order_funnel.route('/order-not-delivered/<orderId>', methods=['POST'])
def report_missing_order(orderId):
    # Reports order as not delivered
    pass