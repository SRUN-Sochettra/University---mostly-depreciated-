// lib/data.dart

/// ----------------------------------------------------------------------------
/// Image sources
/// - Using Wikimedia Commons "Special:FilePath" URLs (redirect to the actual file)
///   These are public domain / Creative Commons licensed images.
/// ----------------------------------------------------------------------------
library;



// --- data.dart (image section) ---
// Wikimedia Commons supports resizing via Special:FilePath?width=... [1](https://www.mediawiki.org/wiki/Help:Linking_to_files)

const String kFallbackImage =
    "https://commons.wikimedia.org/wiki/Special:FilePath/Food%20Delivery%20Service.jpg?width=1200";


final List<String> promoBanners = [
  // Food delivery rider banner
  "https://images.pexels.com/photos/7362948/pexels-photo-7362948.jpeg?auto=compress&cs=tinysrgb&w=1400",

  // Pizza banner
  "https://images.pexels.com/photos/2619967/pexels-photo-2619967.jpeg?auto=compress&cs=tinysrgb&w=1400",

  // Grocery / vegetables banner
  "https://images.pexels.com/photos/31031852/pexels-photo-31031852.jpeg?auto=compress&cs=tinysrgb&w=1400",
];



final List<String> menuItemImages = [
  // Burger
  "https://images.pexels.com/photos/1639562/pexels-photo-1639562.jpeg?auto=compress&cs=tinysrgb&w=600", // [1](https://www.pexels.com/photo/close-up-photo-of-burger-1639562/)

  // Pizza
  "https://images.pexels.com/photos/2619967/pexels-photo-2619967.jpeg?auto=compress&cs=tinysrgb&w=600", // [2](https://amiralimir.com/)

  // Coffee (latte art)
  "https://images.pexels.com/photos/1860202/pexels-photo-1860202.jpeg?auto=compress&cs=tinysrgb&w=600", // [3](https://www.pexels.com/photo/a-cup-of-coffee-with-latte-art-in-close-up-shot-5246890/)

  // Coffee cup beside beans
  "https://images.pexels.com/photos/2456424/pexels-photo-2456424.jpeg?auto=compress&cs=tinysrgb&w=600", // [4](https://www.pexels.com/photo/close-up-photo-of-coffee-cup-beside-coffee-beans-2456424/)

  // Fried chicken
  "https://images.pexels.com/photos/13823475/pexels-photo-13823475.jpeg?auto=compress&cs=tinysrgb&w=600", // [5](https://www.pexels.com/photo/close-up-photo-of-fried-chicken-60616/)

  // Grocery / veggies
  "https://images.pexels.com/photos/31031852/pexels-photo-31031852.jpeg?auto=compress&cs=tinysrgb&w=600", // [6](https://commons.wikimedia.org/wiki/File:AnnaKristinaGroceryBagLogo.jpg)
];


const String kBurgerHero =
    "https://commons.wikimedia.org/wiki/Special:FilePath/Burgers%20for%20Dinner%20%28Unsplash%29.jpg?width=1200";
const String kCoffeeHero =
    "https://commons.wikimedia.org/wiki/Special:FilePath/Coffee%20cup%20surrounded%20by%20coffee%20beans.jpg?width=1200";
const String kChickenHero =
    "https://commons.wikimedia.org/wiki/Special:FilePath/Fried%20Chicken%20%28Unsplash%29.jpg?width=1200";

/// ----------------------------------------------------------------------------
/// Categories (icon is Material Icons codePoint)
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> categories = [
  {'id': 'cat_food', 'name': 'Food', 'icon': 0xe532}, // Icons.fastfood
  {
    'id': 'cat_mart',
    'name': 'Mart',
    'icon': 0xe59c,
  }, // Icons.local_grocery_store
  {
    'id': 'cat_express',
    'name': 'Express',
    'icon': 0xe558,
  }, // Icons.local_shipping
  {'id': 'cat_shops', 'name': 'Shops', 'icon': 0xe541}, // Icons.store
];

/// ----------------------------------------------------------------------------
/// Restaurants
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> restaurants = [
  {
    "id": "r1",
    "name": "Burger House",
    "tags": "Burgers • Fast Food",
    "delivery": "\$1.50",
    "time": "25-35 min",
    "rating": 4.5,
    "image": kBurgerHero,

    "distanceKm": 2.1,
    "minOrder": 5.00,
    "isOpen": true,
    "openUntil": "10:00 PM",
    "priceLevel": 2,
    "promoLabel": "Buy 1 Get 1",
    "featured": true,
  },
  {
    "id": "r2",
    "name": "Coffee Corner",
    "tags": "Coffee • Drinks",
    "delivery": "Free",
    "time": "15-20 min",
    "rating": 4.8,
    "image": kCoffeeHero,

    "distanceKm": 1.3,
    "minOrder": 3.00,
    "isOpen": true,
    "openUntil": "11:30 PM",
    "priceLevel": 2,
    "promoLabel": "10% OFF",
    "featured": true,
  },
  {
    "id": "r3",
    "name": "Fried Chicken Co.",
    "tags": "Chicken • Fried",
    "delivery": "\$2.00",
    "time": "30-45 min",
    "rating": 4.2,
    "image": kChickenHero,

    "distanceKm": 3.6,
    "minOrder": 6.00,
    "isOpen": false,
    "openUntil": "Closed",
    "priceLevel": 2,
    "promoLabel": "Free Drink",
    "featured": false,
  },
];

/// ----------------------------------------------------------------------------
/// Menu data per restaurant (now uses real images)
/// ----------------------------------------------------------------------------
final Map<String, List<Map<String, dynamic>>> menusByRestaurant = {
  "r1": [
    {
      "section": "Popular",
      "items": [
        {
          "id": "r1_p1",
          "name": "Signature Burger",
          "description": "Juicy burger with fresh veggies and house sauce.",
          "price": 4.90,
          "imageUrl": menuItemImages[0],
          "inStock": true,
        },
        {
          "id": "r1_p2",
          "name": "Cheesy Pizza Slice",
          "description": "Cheese + tomato base, hot and satisfying.",
          "price": 2.80,
          "imageUrl": menuItemImages[0],
          "inStock": true,
        },
      ],
    },
    {
      "section": "Mains",
      "items": [
        {
          "id": "r1_m1",
          "name": "Roast Chicken Pizza",
          "description": "Pizza topped with roast chicken and veggies.",
          "price": 5.20,
          "imageUrl": menuItemImages[3],
          "inStock": true,
          "options": [
            {
              "name": "Size",
              "choices": ["Regular", "Large"],
              "prices": [0.0, 2.0],
            },
          ],
          "addons": [
            {"name": "Extra Cheese", "price": 0.50},
          ],
        },
      ],
    },
    {
      "section": "Drinks",
      "items": [
        {
          "id": "r1_d1",
          "name": "Coffee",
          "description": "Freshly brewed coffee.",
          "price": 1.20,
          "imageUrl": menuItemImages[1],
          "inStock": true,
          "options": [
            {
              "name": "Temperature",
              "choices": ["Hot", "Iced"],
              "prices": [0.0, 0.0],
            },
          ],
        },
      ],
    },
  ],

  "r2": [
    {
      "section": "Popular",
      "items": [
        {
          "id": "r2_p1",
          "name": "Coffee Cup",
          "description": "Smooth coffee with rich aroma.",
          "price": 2.40,
          "imageUrl": menuItemImages[2],
          "inStock": true,
        },
      ],
    },
    {
      "section": "Mains",
      "items": [
        {
          "id": "r2_m1",
          "name": "Pizza (Snack)",
          "description": "Light meal to pair with your drink.",
          "price": 2.10,
          "imageUrl": menuItemImages[0],
          "inStock": true,
        },
      ],
    },
    {
      "section": "Drinks",
      "items": [
        {
          "id": "r2_d1",
          "name": "Black Coffee",
          "description": "Simple, bold, and energizing.",
          "price": 1.90,
          "imageUrl": menuItemImages[1],
          "inStock": true,
        },
      ],
    },
  ],

  "r3": [
    {
      "section": "Popular",
      "items": [
        {
          "id": "r3_p1",
          "name": "Fried Chicken",
          "description": "Crispy fried chicken, hot and crunchy.",
          "price": 4.60,
          "imageUrl": menuItemImages[5],
          "inStock": true,
        },
      ],
    },
    {
      "section": "Mains",
      "items": [
        {
          "id": "r3_m1",
          "name": "Chicken + Pizza Combo",
          "description": "A filling combo for serious hunger.",
          "price": 7.80,
          "imageUrl": menuItemImages[3],
          "inStock": true,
        },
      ],
    },
    {
      "section": "Drinks",
      "items": [
        {
          "id": "r3_d1",
          "name": "Coffee",
          "description": "Pairs well with crispy food.",
          "price": 1.40,
          "imageUrl": menuItemImages[1],
          "inStock": true,
        },
      ],
    },
  ],
};

/// ----------------------------------------------------------------------------
/// Fees + rules (future checkout breakdown)
/// ----------------------------------------------------------------------------
final Map<String, dynamic> feeRules = {
  "serviceFeeRate": 0.05,
  "smallOrderThreshold": 6.00,
  "smallOrderFee": 1.00,
  "taxRate": 0.00,
};

/// ----------------------------------------------------------------------------
/// Vouchers / Promotions
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> vouchers = [
  {
    "code": "WELCOME10",
    "title": "10% OFF first order",
    "type": "percent",
    "value": 10,
    "minSubtotal": 5.00,
    "maxDiscount": 2.00,
    "expires": "2026-03-01",
    "active": true,
  },
  {
    "code": "FREESHIP",
    "title": "Free Delivery",
    "type": "free_delivery",
    "value": 0,
    "minSubtotal": 7.00,
    "expires": "2026-02-01",
    "active": true,
  },
];

/// ----------------------------------------------------------------------------
/// Addresses
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> savedAddresses = [
  {
    "id": "addr_1",
    "label": "Home",
    "addressLine": "St. 271, Phnom Penh",
    "note": "Gate is blue, call on arrival",
    "isDefault": true,
  },
  {
    "id": "addr_2",
    "label": "School",
    "addressLine": "Russian Market area",
    "note": "",
    "isDefault": false,
  },
];

/// ----------------------------------------------------------------------------
/// Payment methods
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> paymentMethods = [
  {
    "id": "pay_cash",
    "name": "Cash on delivery",
    "type": "cash",
    "enabled": true,
  },
  {"id": "pay_aba", "name": "ABA Pay", "type": "wallet", "enabled": false},
  {
    "id": "pay_card",
    "name": "Credit/Debit Card",
    "type": "card",
    "enabled": false,
  },
];

/// ----------------------------------------------------------------------------
/// Orders
/// ----------------------------------------------------------------------------
final List<Map<String, dynamic>> orderHistory = [
  {
    "id": "o_1001",
    "restaurant": "Burger House",
    "restaurantId": "r1",
    "date": "Jan 7, 2026 - 12:30 PM",
    "items": "1x Signature Burger, 1x Coffee",
    "total": "\$6.50",
    "status": "Completed",

    "currency": "USD",
    "subtotal": 6.10,
    "deliveryFee": 1.50,
    "serviceFee": 0.30,
    "discount": 1.40,
    "lineItems": [
      {
        "itemId": "r1_p1",
        "name": "Signature Burger",
        "qty": 1,
        "unitPrice": 4.90,
      },
      {"itemId": "r1_d1", "name": "Coffee", "qty": 1, "unitPrice": 1.20},
    ],
  },
];
