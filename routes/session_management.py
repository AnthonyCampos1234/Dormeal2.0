from flask import Blueprint, session, redirect, url_for, request, jsonify

session_management = Blueprint('session_management', __name__)

# Session Management Routes
@session_management.route('/', methods=['GET'])
def home():
    if 'user_id' in session:
        return redirect(url_for('session_management.dashboard'))
    return jsonify({'message': 'Please login or continue as guest'})

@session_management.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    # Add your authentication logic here
    if data and 'username' in data and 'password' in data:
        # Verify credentials (implement your own logic)
        raise NotImplementedError("credential verification is not implemented yet")
        session['user_id'] = data['username']  # Store user info in session
        return jsonify({'message': 'Login successful'})
    return jsonify({'error': 'Invalid credentials'}), 401

@session_management.route('/logout', methods=['POST'])
def logout():
    session.pop('user_id', None)
    return jsonify({'message': 'Logged out successfully'})

@session_management.route('/session', methods=['GET'])
def check_session():
    if 'user_id' in session:
        return jsonify({
            'logged_in': True,
            'user_id': session['user_id']
        })
    return jsonify({'logged_in': False})

@session_management.route('/dashboard', methods=['GET'])
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('session_management.home'))
    return jsonify({'message': f'Welcome to dashboard, {session["user_id"]}'})



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