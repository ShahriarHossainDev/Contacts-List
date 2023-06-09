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
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "EditContact",
           
           let cell = sender as? HomeTableViewCell,
           let indexPath = contactsTabelView.indexPath(for: cell),
           let editViewController = segue.destination as? EditContactViewController {
            print("Going")
            let friend = friendsList[indexPath.row]
           
            let store = CNContactStore()
            
            let predicate = CNContact.predicateForContacts(matchingEmailAddress: friend.workEmail)
            
            let keys = [CNContactPhoneNumbersKey as CNKeyDescriptor]
            
            if let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: keys),
               let contact = contacts.first,
               let contactPhone = contact.phoneNumbers.first {
                
                friend.storedContact = contact.mutableCopy() as? CNMutableContact
                friend.phoneNumberField = contactPhone
                friend.identifier = contact.identifier
            }
            editViewController.friend = friend
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        
        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = false
        
        navigationController?.pushViewController(contactViewController, animated: true)
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
