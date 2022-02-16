//
//  PhoneBookListViewController.swift
//  PhoneBookTuco
//
//  Created by Fernando Leguia on 2022-02-15.
//

import UIKit

class RecordView:UITableViewCell {
    @IBOutlet weak var firtsNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
}

class PhoneBookListViewController: AbstractViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    fileprivate let cellReuseIdentifier = "RecordCell"
    
    lazy var searchButton:UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        var searchIcon = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        
        var button = UIBarButtonItem(image: searchIcon,
                                     style: .plain,
                                     target: self,
                                     action: #selector(showSearchBar(_:)))
        
        return button
    }()
    
    lazy var searchBar:UIBarButtonItem = {
        var searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.sizeToFit()
        var rightButton = UIBarButtonItem(customView: searchBar)
        
        return rightButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddButton()
        configureTitle()
    }
    
    func configureAddButton(){
        addButton.tintColor = UIColor(hex: "#095683")
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }
    
    func configureTitle(){
        let style = NSMutableParagraphStyle()
        let font = UIFont.systemFont(ofSize: 20)
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .font: font]
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Phone Book List",
                                                           image: nil,
                                                           primaryAction: nil,
                                                           menu: nil)
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        
        
    }
    
    @objc func showSearchBar(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = searchBar
        
        var searchItem = (self.navigationItem.rightBarButtonItem?.customView) as! UISearchBar
        searchItem.becomeFirstResponder()
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        UIView.animate(withDuration: 1) { [weak self] in
            self?.bottomConstraint.constant =  keyboardSize.height + 20
            
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.bottomConstraint.constant =   20
        } completion: { _ in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = searchButton
    }
}



extension PhoneBookListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //FILTER
        self.navigationItem.rightBarButtonItem = searchButton
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
    }
}

extension PhoneBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RecordView
        
        cell.firtsNameLabel.text = "Fernando"
        cell.lastNameLabel.text = "Leguia"
        cell.phoneNumberLabel.text = "999-888-7777"
        return cell
    }
}
