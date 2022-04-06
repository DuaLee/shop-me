//
//  CategoryCollection.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import Foundation

class CategoryCollection {
    var category: String
    var cartItems: [CartItem]
    
    init(category: String, cartItems: [CartItem]) {
        self.category = category
        self.cartItems = cartItems
    }
    
    func addItem(cartItem: CartItem) {
        cartItems.append(cartItem)
    }
}
