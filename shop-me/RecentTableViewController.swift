//
//  RecentTableViewController.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import UIKit

class RecentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if orders.count != 0, let recentCell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as? RecentTableViewCell {
            recentCell.configure(order: orders[indexPath.row])
                        
            cell = recentCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            orders.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.image = (self.tableView.isEditing) ? UIImage(systemName: "checkmark") : UIImage(systemName: "square.and.pencil")
    }
}
