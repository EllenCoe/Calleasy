//
//  ContactViewController.swift
//  calling
//
//  Created by Ellen Coelho on 14/03/17.
//  Copyright © 2017 Ellen Coelho. All rights reserved.
//


import UIKit
import ContactsUI
import Contacts

class ContactViewController: CNContactPickerViewController {
    

    @IBOutlet weak var ContactsList: UIButton!

    @IBAction func ActionContact(_ sender: Any) {
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0",
                                                                              argumentArray: nil)
        
        //contactPickerViewController.delegate = self
        //contactPickerViewController.navigationItem.leftBarButtonItem = true
        contactPickerViewController.navigationItem.hidesBackButton = true
        
        present(contactPickerViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var Contact: UIPickerView!
    
  
    
}
