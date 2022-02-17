//
//  AddContactViewController.swift
//  PhoneBookTuco
//
//  Created by Fernando Leguia on 2022-02-16.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var managedObjectContext: NSManagedObjectContext?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor(hex: "#095683")
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 5
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func saveRecord(_ sender: Any) {
        
        guard validateBeforeSave() else { return }
        
        
        guard let managedObjectContext = managedObjectContext else { return }
        
        let record = Record(context: managedObjectContext)
        
        record.firstName = firstNameTextField.text
        record.lastName = lastNameTextField.text
        record.phoneNumber = phoneNumberTextField.text
        
        navigationController?.popViewController(animated: true)
    
    }
    
    func validateBeforeSave() -> Bool {
        
        
        
        if let firstNameText = firstNameTextField.text, !firstNameText.isEmpty {
            
        } else {
            showValidationDialog("First name is required")
            firstNameTextField.becomeFirstResponder()
            return false
        }
        
        if let lastNameText = lastNameTextField.text, !lastNameText.isEmpty {
            
        } else {
            showValidationDialog("Last name is required")
            lastNameTextField.becomeFirstResponder()
            return false
        }
        
        
        if let phoneText = phoneNumberTextField.text, !phoneText.isEmpty {
            
        } else {
            showValidationDialog("Phone number must not be empty")
            phoneNumberTextField.becomeFirstResponder()
            return false
        }
        
        
        
        return true
    }
    
    func showValidationDialog(_ messageText: String){
         let alertController = UIAlertController(title: messageText,
                                                 message: "",
                                                 preferredStyle: .alert)

        let ok = UIAlertAction.init(title: "Ok", style: .default, handler: { action in
            print(action)
        })
        
        alertController.addAction(ok)
        alertController.preferredAction = ok
        present(alertController, animated: true, completion: nil)
    }
    
}
