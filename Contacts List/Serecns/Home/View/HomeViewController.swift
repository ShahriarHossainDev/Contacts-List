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
    
    @IBOutlet weak var contactsTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        // Do any additional setup after loading the view.
    }

}
