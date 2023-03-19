//
//  EditContactViewController.swift
//  Contacts List
//
//  Created by Shishir_Mac on 19/3/23.
//

import UIKit
import Contacts

class EditContactViewController: UIViewController {
    
    var friend: Friend?
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet {
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = 64.0
        }
    }
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var fristNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsView.layer.contents = 5
        contactsView.dropShadow()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function
    
    private func setup() {
        
        guard let friend = friend else {
            fullNameLabel.text = ""
            fristNameTextField.text = ""
            lastNameTextField.text = ""
            emailTextField.text = ""
            phoneTextField.text = ""
            phoneTextField.isEnabled = false
            return
        }
        
        // Full Name
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        if let name = formatter.string(from: friend.contactValue) {
            fullNameLabel.text = name
        } else {
            fullNameLabel.text = "Name Not Available"
        }
        
        fristNameTextField.text = friend.firstName
        lastNameTextField.text = friend.lastName
        emailTextField.text = friend.workEmail
        
        // Int to String (is or is not)
        if let phoneNumberField = friend.phoneNumberField {
            phoneTextField.text = phoneNumberField.value.stringValue
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        phoneTextField.resignFirstResponder()
        
        let store = CNContactStore()
        
        guard let friend = friend, let phoneNumberText = phoneTextField.text else { return }
        
        let phoneNumberValue = CNPhoneNumber(stringValue: phoneNumberText)
        let saveRequest = CNSaveRequest()
        
        if let storedContact = friend.storedContact,
           let phoneNumberToEdit = storedContact.phoneNumbers.first( where: {
               $0 == friend.phoneNumberField
           }), let index = storedContact.phoneNumbers.firstIndex(of: phoneNumberToEdit) {
            
            // Save
            let newPhoneNumberField = phoneNumberToEdit.settingValue(phoneNumberValue)
            storedContact.phoneNumbers.remove(at: index)
            storedContact.phoneNumbers.insert(newPhoneNumberField, at: index)
            friend.phoneNumberField = newPhoneNumberField
            // Update contacts
            saveRequest.update(storedContact)
            friend.storedContact = nil
        } else if let unsavedContact = friend.contactValue.mutableCopy() as? CNMutableContact {
            // Unsaved Contact
            let phoneNumberField = CNLabeledValue(label: CNLabelPhoneNumberMain,
                                                  value: phoneNumberValue)
            unsavedContact.phoneNumbers = [phoneNumberField]
            friend.phoneNumberField = phoneNumberField
            // save contact
            saveRequest.add(unsavedContact, toContainerWithIdentifier: nil)
        }
        
        do {
            try store.execute(saveRequest)
            let controller = UIAlertController(title: "Success",message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
            setup()
        } catch {
            print(error.localizedDescription)
        }
    }
}
