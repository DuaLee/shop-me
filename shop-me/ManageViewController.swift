//
//  ManageViewController.swift
//  shop-me
//
//  Created by Cony Lee on 3/3/22.
//

import UIKit
import AudioToolbox

class ManageViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var categoryImagePreview: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var taxInput: UITextField!
    @IBOutlet weak var shippingInput: UITextField!
    @IBOutlet weak var currencyInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryInput.delegate = self
        self.nameInput.delegate = self
        self.descriptionInput.delegate = self
        self.priceInput.delegate = self
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.categoryInput:
            self.nameInput.becomeFirstResponder()
        case self.nameInput:
            self.descriptionInput.becomeFirstResponder()
        case self.descriptionInput:
            self.priceInput.becomeFirstResponder()
        default:
            self.priceInput.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    var imageBeingSelectedIndex: Int = 0
    
    @IBAction func imageSelectButton(_ sender: UIButton) {
        switch sender.tag {
        case 800:
            imageBeingSelectedIndex = 0
            
            
        case 801:
            imageBeingSelectedIndex = 1
            
            
        default:
            break
            
        }
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated:true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            if imageBeingSelectedIndex == 0 {
                imagePreview.image = image
            } else if imageBeingSelectedIndex == 1 {
                categoryImagePreview.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 600:
            if !categoryInput.text!.isEmpty, !nameInput.text!.isEmpty, !descriptionInput.text!.isEmpty, !priceInput.text!.isEmpty {
                var categoryExists = false
                var newMessage = ""
                
                for category in categories {
                    if category.name == categoryInput.text! {
                        categoryExists = true
                        
                        break
                    }
                }
                
                if categoryExists == false {
                    newMessage += "New category added: \(categoryInput.text!)"
                    
                    categories.append(Category(name: categoryInput.text!, image: categoryImagePreview.image!))
                }
                
                items.append(Item(category: categoryInput.text!, name: nameInput.text!, description: descriptionInput.text!, price: Float32(priceInput.text!)!, image: imagePreview.image!))
                
                let alert = UIAlertController(title: "⚙️ Item added!", message: newMessage, preferredStyle: .alert)
                
                self.present(alert, animated: true, completion: nil)
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Fields cannot be empty!", message: "", preferredStyle: .alert)
                
                self.present(alert, animated: true, completion: nil)
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        case 601:
            let alert = UIAlertController(title: "Are you sure you want to reset the text fields?", message: "This action cannot be reversed.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Reset", style: .destructive, handler: { action in
                self.confirmClear()
            })
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func confirmClear() {
        categoryInput.text = ""
        nameInput.text = ""
        descriptionInput.text = ""
        priceInput.text = ""
        imagePreview.image = UIImage(systemName: "questionmark.square.dashed")!
    }
    
    @IBOutlet weak var removeInput: UITextField!
    
    @IBAction func removeButton(_ sender: UIButton) {
        var isFound: Bool = false
        
        switch sender.tag {
        case 900:
            for index in 0..<categories.count {
                if categories[index].name == removeInput.text {
                    isFound = true
                    
                    let alert = UIAlertController(title: "⚠️ Are you sure you want to remove category \(removeInput.text!)?", message: "This action will also remove all items in the category.\n(Action will automatically cancel in 10 seconds)", preferredStyle: .actionSheet)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "Remove", style: .destructive, handler: { action in
                        self.confirmDestruction(index: index)
                    })
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 10
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    break
                }
            }
        case 901:
            for index in 0..<items.count {
                if items[index].name == removeInput.text {
                    isFound = true
                    
                    items.remove(at: index)
                    
                    let alert = UIAlertController(title: "⚙️ Item removed!", message: "", preferredStyle: .alert)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    break
                }
            }
        default:
            break
        }
        
        if isFound == false {
            let alert = UIAlertController(title: "❓ Not found!", message: "Please check spelling and/or capitalization.", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func confirmDestruction(index: Int) {
        categories.remove(at: index)
        
        items.removeAll(where: {$0.category == removeInput.text!})
        
        let alert = UIAlertController(title: "⚙️ Category removed!", message: "", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func applyConstantsButton(_ sender: Any) {
        var editAlertMessage: String = ""
        
        if !taxInput.text!.isEmpty {
            taxRate = Float32(taxInput.text!)!
            
            editAlertMessage += "Tax\n"
        }
        if !shippingInput.text!.isEmpty {
            shippingCost = Float32(shippingInput.text!)!
            
            editAlertMessage += "Shipping\n"
        }
        if !currencyInput.text!.isEmpty {
            currencySymbol = String(currencyInput.text!)
            
            editAlertMessage += "Currency\n"
        }
        
        let alert = UIAlertController(title: "⚙️ Updated constants!", message: String(editAlertMessage.dropLast()), preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
