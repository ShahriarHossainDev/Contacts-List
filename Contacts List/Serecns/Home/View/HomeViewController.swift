//
//  HomeViewController.swift
//  Contacts List
//
//  Created by Shishir_Mac on 19/3/23.
//

import UIKit
import ContactsUI

class HomeViewController: UIViewController {
    
    var friendsList = Friend.defaultContacts()
    
    private let cellIdentifier: String = "homeCell"
    
    @IBOutlet weak var contactsTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contacts"
        
        contactsTabelView.delegate = self
        contactsTabelView.dataSource = self
        
        self.contactsTabelView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - IBAction
    @IBAction func addFriendsBarButtonAction(_ sender: UIBarButtonItem) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true)
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeTableViewCell {
            //cell.configurateTheCell(recipes[indexPath.row])
            let friend = friendsList[indexPath.row]
            cell.friend = friend
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
}

//MARK: - CNContactPickerDelegate
extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let newFriends = contacts.compactMap { Friend(contact: $0) }
        for friend in newFriends {
            if !friendsList.contains(friend) {
                friendsList.append(friend)
            }
        }
        contactsTabelView.reloadData()
    }
}
