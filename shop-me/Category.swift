//
//  Category.swift
//  shop-me
//
//  Created by Cony Lee on 3/4/22.
//

import Foundation
import UIKit

class Category {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    init(name: String) {
        self.name = name
        self.image = UIImage(named: "\(name).png")!
    }
}
