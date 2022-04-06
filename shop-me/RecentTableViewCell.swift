//
//  RecentTableViewCell.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(order: Order) {
        dateLabel.text = order.dateToString()
        priceLabel.text = String(format: "\(currencySymbol)%.2f", order.price)
        quantityLabel.text = String(order.quantity)
    }

}
