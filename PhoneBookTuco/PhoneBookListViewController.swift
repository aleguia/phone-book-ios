//
//  PhoneBookListViewController.swift
//  PhoneBookTuco
//
//  Created by Fernando Leguia on 2022-02-15.
//

import UIKit
import CoreData

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
    
    //Core Data
    private let persistentContainer = NSPersistentContainer(name: "Records")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Record> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName",
                                                         ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
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
        subscribeToNotifications()
        configureAddButton()
        configureTitle()
        loadPersistentStore()
    }
    
    func subscribeToNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    func loadPersistentStore(){
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.updateView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
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
    
    private func updateView() {
        var hasRecords = false
        
        if let records = fetchedResultsController.fetchedObjects {
            hasRecords = records.count > 0
        }
        
        tableView.isHidden = !hasRecords
        //            messageLabel.isHidden = hasQuotes
        
        //            activityIndicatorView.stopAnimating()
    }
    
    @objc func showSearchBar(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = searchBar
        
        var searchItem = (self.navigationItem.rightBarButtonItem?.customView) as! UISearchBar
        searchItem.becomeFirstResponder()
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd"{
            var vc = segue.destination as! AddContactViewController
            vc.managedObjectContext = persistentContainer.viewContext
        }
    }
}



extension PhoneBookListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //FILTER
        self.navigationItem.rightBarButtonItem = searchButton
        //        searchBar.text = ""
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        filter(with: "")
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
    }
}

extension PhoneBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let records = fetchedResultsController.fetchedObjects else { return 0 }
        return records.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RecordView
        
        let record = fetchedResultsController.object(at: indexPath)
        
        cell.firtsNameLabel.text = record.firstName
        cell.lastNameLabel.text = record.lastName
        cell.phoneNumberLabel.text = record.phoneNumber
        return cell
    }
}

extension PhoneBookListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
            
        case .move:
            print("is moving")
            break;
            
        default:
            print("...")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func filter(with searchText:String){
        let firstNamePredicate = NSPredicate(format: "firstName CONTAINS[c] %@", searchText)
        
        let lastNamePredicate = NSPredicate(format: "lastName CONTAINS[c] %@", searchText)
        
        let phonePredicate = NSPredicate(format: "phoneNumber CONTAINS[c] %@", searchText)
        
        if !searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                firstNamePredicate,
                lastNamePredicate,
                phonePredicate
            ])
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }

        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            
        }
    }
}
