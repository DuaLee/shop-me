//
//  TableViewCell.swift
//  shop-me
//
//  Created by Cony Lee on 3/2/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var addCartButton: UIButton!
    
    var item: Item?
    
    weak var delegate: ItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonTappedFor(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: Item) {
        self.itemName.text = item.name
        self.itemDescription.text = item.description
        self.itemPrice.text = String(format: "\(currencySymbol)%.2f", item.price)
        self.itemImage.image = item.image
    }
}
