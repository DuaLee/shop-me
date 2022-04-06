//
//  CartItems.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import Foundation
class CartItem {
    var item: Item
    var quantity: Int
    
    init(item: Item, quantity: Int) {
        self.item = item
        self.quantity = quantity
    }
}
