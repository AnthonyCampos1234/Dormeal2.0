import Foundation

extension Order {
    static var sampleOrder: Order {
        let building = Building(
            id: "b1",
            name: "Warren College",
            location: "Warren Campus"
        )
        
        let user = User(
            id: "u1",
            homeBuilding: building,
            name: "John Doe",
            phoneNumber: "+1234567890"
        )
        
        let menu = RestaurantMenu(
            id: "r1",
            restaurantName: "Panda Express",
            logo: "https://example.com/logo.png",
            location: "Price Center",
            categories: ["Chinese", "Asian"],
            menu: [
                MenuItem(
                    id: "m1",
                    name: "Orange Chicken",
                    price: 12.99,
                    description: "Crispy chicken in sweet orange sauce",
                    category: "Entrees",
                    imageUrl: "https://example.com/orange-chicken.jpg",
                    optionGroups: [
                        MenuItemOptionGroup(
                            id: "rice",
                            name: "Choose your rice",
                            required: true,
                            multiSelect: false,
                            minSelections: 1,
                            maxSelections: 1,
                            options: [
                                MenuItemOption(id: "white", name: "White Rice", price: 0),
                                MenuItemOption(id: "brown", name: "Brown Rice", price: 0)
                            ]
                        )
                    ]
                )
            ]
        )
        
        let items: [Item] = [
            Item(
                id: "i1",
                name: "Orange Chicken",
                basePrice: 12.99,
                addonsSections: [],
                additionalsSections: [],
                choicesSections: [],
                icon: "orange-chicken-icon"
            )
        ]
        
        let cart = Cart(
            id: "c1",
            menu: menu,
            items: items,
            totalPrice: 12.99
        )
        
        return Order(
            id: "o1",
            cart: cart,
            building: building,
            carrier: nil,
            status: "pending",
            user: user,
            location: "Warren College",
            totalPrice: 12.99,
            carrierPayout: 3.00,
            deliveryMethod: DeliveryMethod.dropoff,
            createdAt: Date()
        )
    }
    
    static var sampleHandoffOrder: Order {
        let building = Building(
            id: "b2",
            name: "Sixth College",
            location: "Sixth Campus"
        )
        
        let user = User(
            id: "u2",
            homeBuilding: building,
            name: "Jane Smith",
            phoneNumber: "+1987654321"
        )
        
        let menu = RestaurantMenu(
            id: "r2",
            restaurantName: "Subway",
            logo: "https://example.com/subway-logo.png",
            location: "Price Center",
            categories: ["Sandwiches", "Fast Food"],
            menu: [
                MenuItem(
                    id: "m2",
                    name: "Italian BMT",
                    price: 9.99,
                    description: "Classic Italian sub",
                    category: "Subs",
                    imageUrl: "https://example.com/bmt.jpg",
                    optionGroups: [
                        MenuItemOptionGroup(
                            id: "bread",
                            name: "Choose your bread",
                            required: true,
                            multiSelect: false,
                            minSelections: 1,
                            maxSelections: 1,
                            options: [
                                MenuItemOption(id: "italian", name: "Italian", price: 0),
                                MenuItemOption(id: "wheat", name: "Wheat", price: 0)
                            ]
                        )
                    ]
                )
            ]
        )
        
        let items: [Item] = [
            Item(
                id: "i2",
                name: "Italian BMT",
                basePrice: 9.99,
                addonsSections: [],
                additionalsSections: [],
                choicesSections: [],
                icon: "sub-icon"
            )
        ]
        
        let cart = Cart(
            id: "c2",
            menu: menu,
            items: items,
            totalPrice: 9.99
        )
        
        return Order(
            id: "o2",
            cart: cart,
            building: building,
            carrier: nil,
            status: "pending",
            user: user,
            location: "Room 234",
            totalPrice: 9.99,
            carrierPayout: 3.50,
            deliveryMethod: DeliveryMethod.handoff,
            createdAt: Date()
        )
    }
}

