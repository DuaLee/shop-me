//
//  CollectionViewController.swift
//  shop-me
//
//  Created by Cony Lee on 3/1/22.
//

// Config (EDITABLE) //
var categories: [Category] = []
var currencySymbol: String = "$"
var taxRate: Float32 = 0.06
var shippingCost: Float32 = 3.99
var isTesting: Bool = false

// Global Variables //
var items: [Item] = []
var cartItems: [CartItem] = []
var orders: [Order] = []

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let spacing: CGFloat = 0.0
    
    var tagCounter: Int = 0
    
    @IBOutlet weak var cartCount: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTesting == true {
            testData()
        }
        
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        cartCount.title = "\(cartCounter)"
    }
    
    func testData() {
        // Categories
        categories.append(Category(name: "Grocery"))
        categories.append(Category(name: "Clothing"))
        categories.append(Category(name: "Movies"))
        categories.append(Category(name: "Garden"))
        categories.append(Category(name: "Electronics"))
        categories.append(Category(name: "Books"))
        categories.append(Category(name: "Appliances"))
        categories.append(Category(name: "Toys"))
        
        // Grocery
        items.append(Item(category: "Grocery", name: "Banana", description: "Organic", price: 0.49))
        items.append(Item(category: "Grocery", name: "Durian", description: "Imported from Vietnam", price: 50.69))
        
        // Clothing
        items.append(Item(category: "Clothing", name: "Shirt", description: "White", price: 5.99))
        items.append(Item(category: "Clothing", name: "Jacket", description: "Red geniune leather", price: 79.99))
        
        //Movies
        items.append(Item(category: "Movies", name: "Up", description: "Carl Fredricksen, a 78-year-old balloon salesman, is about to fulfill a lifelong dream. Tying thousands of balloons to his house, he flies away to the South American wilderness.", price: 15.99))
        items.append(Item(category: "Movies", name: "Inception", description: "Dom Cobb (Leonardo DiCaprio) is a thief with the rare ability to enter people's dreams and steal their secrets from their subconscious.", price: 14.00))
        
        //Garden
        items.append(Item(category: "Garden", name: "Tractor", description: "Kills grass", price: 4950.00))
        items.append(Item(category: "Garden", name: "Hoe", description: "Tills grass", price: 10.99))
        
        //Electronics
        items.append(Item(category: "Electronics", name: "Canon EOS R5", description: "Full-frame mirrorless camera features a newly developed 45MP CMOS sensor, which offers 8K raw video recording.", price: 4599.49))
        items.append(Item(category: "Electronics", name: "MacBook Pro", description: "Apple computers", price: 2050.00))
        
        //Books
        items.append(Item(category: "Books", name: "Lord of The Flies", description: "Piggy dies", price: 4.60))
        items.append(Item(category: "Books", name: "Fahrenheit 451", description: "In a dystopian future where all books are banned and burned, a fireman rebels and begins to read in secret, discovering an underground rebellion determined to protect literature.", price: 3.69))
        
        //Appliances
        items.append(Item(category: "Appliances", name: "Samsung Fridge", description: "Keeps kimchi fresh", price: 3949.99))
        items.append(Item(category: "Appliances", name: "Whirlpool Washer", description: "Buy our clothing and clean it too", price: 950.89))
        
        //Toys
        items.append(Item(category: "Toys", name: "Rex Action Figure", description: "Toy Story", price: 30.09))
        items.append(Item(category: "Toys", name: "Fidget Spinner", description: "Imported from China", price: 1.69))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 1
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            categoryCell.configure(category: categories[indexPath.row], tag: tagCounter)
            
            cell = categoryCell
        }
        
        tagCounter += 1
        
        return cell
    }
    
    var senderTag = 0
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        senderTag = sender.tag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemsTableViewController {
            let vc = segue.destination as? ItemsTableViewController
            
            var category: Category
            
            category = categories[senderTag]
            
            vc?.category = category
        }
    }
    
    override func viewWillAppear (_ animated: Bool) {
        collectionView.reloadData()
        tagCounter = 0
        
        var cartCounter = 0
        
        for cartItem in cartItems {
            cartCounter += cartItem.quantity
        }
        
        cartCount.title = "\(cartCounter)"
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
    }
}
