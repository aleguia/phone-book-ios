//
//  AddContactViewController.swift
//  PhoneBookTuco
//
//  Created by Fernando Leguia on 2022-02-16.
//

import UIKit

class AddContactViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor(hex: "#095683")
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 5
        saveButton.setTitleColor(.white, for: .normal)
    }

}
