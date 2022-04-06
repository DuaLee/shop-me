//
//  protocol.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import Foundation

protocol ItemTableViewCellDelegate : AnyObject {
    func buttonTappedFor(_ tag: Int)
}
