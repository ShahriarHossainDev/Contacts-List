//
//  EditContactViewController.swift
//  Contacts List
//
//  Created by Shishir_Mac on 19/3/23.
//

import UIKit

class EditContactViewController: UIViewController {
    
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
        
        self.title = "Contacts"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        print("Save")
    }
}
