//
//  TableViewController.swift
//  shop-me
//
//  Created by Cony Lee on 3/1/22.
//

import UIKit
import AudioToolbox

class ItemsTableViewController: UITableViewController, ItemTableViewCellDelegate {
    func buttonTappedFor(_ tag: Int) {
        //print("pressed button \(tag). \(categoryTable[tag].name)")
        
        if !cartItems.isEmpty {
            for index in 0..<cartItems.count {
                if cartItems[index].item.name == categoryTable[tag].name {
                    cartItems[index].quantity += 1
                    
                    break
                } else if index == cartItems.count - 1 {
                    cartItems.append(CartItem(item: categoryTable[tag], quantity: 1))
                }
            }
        } else {
            cartItems.append(CartItem(item: categoryTable[tag], quantity: 1))
        }
        
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        cartCount.title = "\(cartCounter)"
        
        let alert = UIAlertController(title: "✔️ Added to cart!", message: "\(categoryTable[tag].name)", preferredStyle: .alert)
                    
        self.present(alert, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var cartCount: UIBarButtonItem!
    var categoryTable: [Item] = []
    
    var category: Category = Category(name: "Unknown", image: UIImage(systemName: "questionmark.square.dashed")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = category.name
        
        populateCategoryTable()
        
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        cartCount.title = "\(cartCounter)"
    }
    
    func populateCategoryTable() {
        for item in items {
            if (item.category == category.name) {
                categoryTable.append(item)
            }
        }
        
        categoryTable = categoryTable.sorted(by: {$0.name < $1.name})
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTable.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if categoryTable.count != 0, let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemTableViewCell {
            itemCell.configure(item: categoryTable[indexPath.row])
            
            itemCell.delegate = self
            itemCell.addCartButton.tag = indexPath.row
            
            cell = itemCell
        }

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        cartCount.title = "\(cartCounter)"
    }
}
