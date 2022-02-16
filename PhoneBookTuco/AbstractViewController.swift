//
//  AbstractViewController.swift
//  PhoneBookTuco
//
//  Created by Fernando Leguia on 2022-02-16.
//

import UIKit

class AbstractViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        else {
//            // if keyboard size is not available for some reason, dont do anything
//            return
//        }
//
//        guard let scrollView = scrollView else {
//            return
//        }
//
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//        guard let scrollView = scrollView else {
//            return
//        }
//
//        // reset back the content inset to zero after keyboard is gone
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
    }

}
