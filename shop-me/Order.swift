//
//  Order.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import Foundation

class Order {
    var date: Date
    var price: Float32
    var quantity: Int
    
    init(date: Date, price: Float32, quantity: Int) {
        self.date = date
        self.price = price
        self.quantity = quantity
    }
    
    func dateToString() -> String {
        return date.description
    }
}
