//
//  CartViewController.swift
//  shop-me
//
//  Created by Cony Lee on 3/2/22.
//

import UIKit
import AudioToolbox

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartTableViewCellDelegate {
    
    func buttonTappedFor(_ tag: Int, _ value: Double) {
        print("\(tag) \(value)")
        
        if Int(value) > cartItems[tag].quantity {
            let alert = UIAlertController(title: "➕ Added 1 \(cartItems[tag].item.name)", message: "", preferredStyle: .alert)

            self.present(alert, animated: true, completion: nil)

            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            cartItems[tag].quantity += 1
            refreshData()
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else if Int(value) == 0 {
            let alert = UIAlertController(title: "🗑 Removed \(cartItems[tag].item.name)", message: "", preferredStyle: .alert)

            self.present(alert, animated: true, completion: nil)

            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            cartItems.remove(at: tag)
            refreshData()
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "➖ Removed 1 \(cartItems[tag].item.name)", message: "", preferredStyle: .alert)

            self.present(alert, animated: true, completion: nil)

            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            cartItems[tag].quantity -= 1
            refreshData()
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryCollectionArray = [CategoryCollection]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !categoryCollectionArray.isEmpty {
            return categoryCollectionArray[section].cartItems.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        var count = 0
//        var categoryRead = ""
//
//        for cartItem in cartItems {
//            if cartItem.item.category != categoryRead {
//                categoryRead = cartItem.item.category
//                count += 1
//            }
//        }
//
//        print("\(count)")
//
//        return count
        
        return categoryCollectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryCollectionArray[section].category
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var quantityPerCategorySum = 0
        
        for cartItem in categoryCollectionArray[section].cartItems {
            quantityPerCategorySum += cartItem.quantity
        }
        
        return "\(quantityPerCategorySum) items"
    }
    
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//            for cartItem in cartItems {
//                print("\(cartItem.item.name) | \(cartItem.quantity)")
//            }
        
        // sort alphabetically by name first, then sort alphabetically by category
        cartItems = cartItems.sorted(by: {$0.item.name < $1.item.name})
        cartItems = cartItems.sorted(by: {$0.item.category < $1.item.category})
        
        refreshData()
        
//        for cartItem in cartItems {
//            print("\(cartItem.item.name) | \(cartItem.quantity)")
//        }
//
//        print("sorted")
//
//        for category in categoryCollectionArray {
//            print("---\(category.category)")
//        }
    }
    
    func refreshData() {
        categoryCollectionArray.removeAll()
        
        for cartItem in cartItems {
            if categoryCollectionArray.count > 0 {
                for index in 0..<categoryCollectionArray.count {
                    if cartItem.item.category == categoryCollectionArray[index].category {
                        categoryCollectionArray[index].addItem(cartItem: cartItem)
                    } else if index == categoryCollectionArray.count - 1 {
                        categoryCollectionArray.append(CategoryCollection(category: cartItem.item.category, cartItems: [cartItem]))
                    }
                }
            } else {
                categoryCollectionArray.append(CategoryCollection(category: cartItem.item.category, cartItems: [cartItem]))
            }
        }
        
        tableView.reloadData()
        
        taxLabel.text = String(format: "Tax: \(currencySymbol)%.2f", calculateSubtotal() * taxRate)
        shippingLabel.text = String(format: "Shipping: \(currencySymbol)%.2f", shippingCost)
        grandTotalLabel.text = String(format: "Grand Total: \(currencySymbol)%.2f", calculateTotalCost())
    }
    
    func calculateSubtotal() -> Float32 {
        var total: Float32 = 0
        
        for cartItem in cartItems {
            total += cartItem.item.price * Float32(cartItem.quantity)
        }
        
        return round(total * 100) / 100.0
    }
    
    func calculateTotalCost() -> Float32 {
        var total: Float32 = 0
        
        for cartItem in cartItems {
            total += cartItem.item.price * Float32(cartItem.quantity)
        }
        
        total = total * (taxRate + 1) + shippingCost
        
        return round(total * 100) / 100.0
    }
    
    func calculateTotalQuantity() -> Int {
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        return cartCounter
    }
    
    @IBAction func buttonTap(_ sender: UIButton) {
        switch sender.tag {
        case 500:
            clearCart()
        case 501:
            purchase()
        default:
            break
        }
    }
    
    func clearCart() {
        let alert = UIAlertController(title: "Are you sure you want to clear your cart?", message: "This action cannot be reversed.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Clear Cart", style: .destructive, handler: { action in
            self.confirmClearCart()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmClearCart() {
        cartItems.removeAll()
        
        let alert = UIAlertController(title: "🗑 Cart cleared!", message: "", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        }
    }
    
    func purchase() {
        if !cartItems.isEmpty {
            let alert = UIAlertController(title: "Order \(calculateTotalQuantity()) items?", message: "\(currencySymbol)\(calculateTotalCost()) will be charged to your card.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Place Order", style: .default, handler: { action in
                self.confirmPurchase()
            })
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Your cart is empty!", message: "", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func confirmPurchase() {
        if orders.count >= 10 {
            orders.remove(at: 0)
        }
        
        orders.append(Order(date: Date(), price: calculateTotalCost(), quantity: calculateTotalQuantity()))
        
        cartItems.removeAll()
        
        let alert = UIAlertController(title: "✈️ Order placed!", message: "", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if cartItems.count != 0, let itemCell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartTableViewCell {
            itemCell.configure(cartItem: categoryCollectionArray[indexPath.section].cartItems[indexPath.row])
            
            itemCell.delegate = self
            
            var temp = 0
            
            if indexPath.section >= 1 {
                temp = tableView.numberOfRows(inSection: indexPath.section - 1)
            }
            
            itemCell.stepper.tag = indexPath.row + temp
            
            cell = itemCell
        }
        
        return cell
    }
}
