//
//  CollectionViewCell.swift
//  shop-me
//
//  Created by Cony Lee on 3/1/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryIcon: UIButton!
    
    func configure(category: Category, tag: Int) {
        categoryIcon.tag = tag
        
        let image = category.image
        
        categoryIcon.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        
        categoryIcon.setBackgroundImage(image, for: .normal)
        
        categoryLabel.text = "\(category.name)"
    }
}
