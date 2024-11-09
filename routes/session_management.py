from flask import Blueprint

session_management = Blueprint('session_management', __name__)

# Session Management Routes
@session_management.route('/', methods=['GET'])
def home():
    # Handle login redirect or guest prompt
    pass

@session_management.route('/login', methods=['POST'])
def login():
    # Handle login credentials and redirect
    pass

@session_management.route('/logout', methods=['POST'])
def logout():
    # Handle logout
    pass

@session_management.route('/session', methods=['GET'])
def check_session():
    # Check if user is in session
    pass

@session_management.route('/dashboard', methods=['GET'])
def dashboard():
    # Handle dashboard redirect logic
    pass



menu = {
    "restaurant_id": "1234567890",
    "restaurant_name": "McDonald's", 
    "sections": [
        {
            "section_id": "1234567890",
            "section_name": "Burgers",
            "items": [
                {
                    "item_id": "1234567890",
                    "item_name": "Big Mac",
                    "price": 5.99,
                    "image_link": "https://www.mcdonalds.com/content/dam/sites/usa/nfl/nutrition/items/hero/desktop/t-mcd-filet-o-fish_2.png",
                    "menu_sections": [
                        {
                            "section_id": "1234567890",
                            "section_type": "addon",
                            "section_name": "Burgers",
                            "options": [
                                {
                                    "option_id": "1234567890",
                                    "option_name": "No pickles",
                                    "price": 0.00
                                },
                                {
                                    "option_id": "1234567891",
                                    "option_name": "Extra pickles",
                                    "price": 0.00
                                }
                            ]
                        },
                        {
                            "section_id": "1234567891",
                            "section_type": "choice",
                            "section_name": "Drinks",
                            "options": [
                                {
                                    "option_id": "1234567890",
                                    "option_name": "Coke",
                                    "price": 1.99
                                },
                                {
                                    "option_id": "1234567891",
                                    "option_name": "Diet Coke",
                                    "price": 1.99
                                },
                                {
                                    "option_id": "1234567892",
                                    "option_name": "Sprite",
                                    "price": 1.99
                                }
                            ]
                        },
                        {
                            "section_id": "1234567892",
                            "section_type": "additional",
                            "section_name": "Sides",
                            "options": [
                                {
                                    "item_id": "1234567890",
                                    "item_name": "French Fries",
                                    "price": 1.99,
                                    "image_link": "https://www.mcdonalds.com/content/dam/sites/usa/nfl/nutrition/items/hero/desktop/t-mcd-filet-o-fish_2.png"
                                },
                                {
                                    "item_id": "1234567891",
                                    "item_name": "Chicken Nuggets",
                                    "price": 2.99,
                                    "image_link": "https://www.mcdonalds.com/content/dam/sites/usa/nfl/nutrition/items/hero/desktop/t-mcd-filet-o-fish_2.png"
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "section_id": "1234567891",
            "section_name": "Drinks"
        }
    ]
}