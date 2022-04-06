//
//  CartTableViewCell.swift
//  shop-me
//
//  Created by Cony Lee on 3/2/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var count: UILabel!
    
    weak var delegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        delegate?.buttonTappedFor(sender.tag, stepper.value)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(cartItem: CartItem) {
        item.text = cartItem.item.name
        price.text = String(format: "\(currencySymbol)%.2f", cartItem.item.price * Float32(cartItem.quantity))
        count.text = String(cartItem.quantity)
        stepper.value = Double(cartItem.quantity)
    }

}
