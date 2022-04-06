//
//  CartTableCellDelegate.swift
//  shop-me
//
//  Created by Cony Lee on 3/4/22.
//

import Foundation

protocol CartTableViewCellDelegate : AnyObject {
    func buttonTappedFor(_ tag: Int, _ value: Double)
}
