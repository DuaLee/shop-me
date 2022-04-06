//
//  item.swift
//  shop-me
//
//  Created by Cony Lee on 3/1/22.
//

import Foundation
import UIKit

class Item {
    var category: String
    var name: String
    var description: String
    var price: Float32
    var image: UIImage
    
    init(category: String = "Unknown", name: String = "Item", description: String = "This is an item", price: Float32 = 1.00, image: UIImage = UIImage(systemName: "questionmark.square.dashed")!) {
        self.category = category
        self.name = name
        self.description = description
        self.price = price
        self.image = image
    }
    
    init(category: String = "Unknown", name: String = "Item", description: String = "This is an item", price: Float32 = 1.00) {
        self.category = category
        self.name = name
        self.description = description
        self.price = price
        self.image = UIImage(named: "\(name).jpeg")!
    }
}
