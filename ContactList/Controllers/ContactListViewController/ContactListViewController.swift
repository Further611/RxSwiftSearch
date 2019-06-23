//
//  ContactListViewController.swift
//  contactlist
//
//  Created by Tien Tran on 6/19/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift

class ContactListViewController: BaseViewController {

    // MARK: - Variable
    @IBOutlet weak var tableView: UITableView!
    
    private var contacts: [Contact] = []
    private var filteredContacts: [Contact] = []
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Notify.shared.removeListener(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        customizeNavigateView()
        setupChildViews()
    }
    
    private func customizeNavigateView() {
        
        navigationItem.title = String.localizeFrom(key: "ContactListViewController_Title")
        
        navigationController?.navigationBar.isTranslucent = true
        
        setupSearchView()
    }
    
    private func setupChildViews() {
        
        // Table View Settings
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UINib.init(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchView() {
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = String.localizeFrom(key: "ContactListViewController_SearchPlaceHolder")
        searchController.searchBar.setValue(String.localizeFrom(key: "ContactListViewController_SearchCancelButton"), forKey:"_cancelButtonText")
        
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.tintColor = kYellowColor.hexColor()
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = kYellowColor.hexColor()
        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchController.searchBar)]).tintColor = kYellowColor.hexColor()
        
        observerChangeDataFromSearchBar()
    }
    
    private func observerChangeDataFromSearchBar() {
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.filterContentForSearchText(self.searchController.searchBar.text!)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupData () {
        // Notification History
        Notify.shared.listen(self, selector: #selector(contactListUpdated(_:)), name: Notify.Name.Contact.list, object: nil)
        
        // API requests
        Apify.shared.getContactList()
    }
    
    // MARK: - Private Functions
    private func moveToDetailWith(_ currentContact: Contact) {
        let contactDetailVC = ContactDetailViewController()
        contactDetailVC.setContact(currentContact)
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return (searchController.isActive && !searchBarIsEmpty())
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredContacts = contacts.filter({( contact : Contact) -> Bool in
            return contact.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    // MARK: - Notification Handlers
    @objc fileprivate func contactListUpdated(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool {
            if success {
                if let json = notification.userInfo!["json"] as? JSON {
                    if let dicArr = json.array {
                        for item in dicArr {
                            let aContact = Contact(item)
                            contacts.append(aContact)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ContactListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredContacts.count : contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell") as! ContactListTableViewCell
        
        let currentContact = isFiltering() ? filteredContacts[indexPath.row] : contacts[indexPath.row]
        cell.configCellWith(currentContact)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailContact = isFiltering() ? filteredContacts[indexPath.row] : contacts[indexPath.row]
        moveToDetailWith(detailContact)
    }
}

// MARK: - UISearchResultsUpdating
extension ContactListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}
