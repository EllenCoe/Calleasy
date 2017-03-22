//
//  ListContactView.swift
//  calling
//
//  Created by Ellen Coelho on 21/03/17.
//  Copyright © 2017 Ellen Coelho. All rights reserved.
//

import UIKit
import Foundation

class ListContactView : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableViewAllContact: UITableView!
    
     var array:[String]=["1","2","3","4","5","6","7","8","9","20"]
    var  data :[String]?
    var allContactList :[ContactStructModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil);
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableViewAllContact.dequeueReusableCell(withIdentifier: "IdentififierCell", for: indexPath) as! contactCellTableView
        cell.nameContact.text = data?[indexPath.row]
        
        for contact in (allContactList)!{
            if(indexPath.row < (data?.count)!){
                if(contact.name == data?[indexPath.row]){
                    cell.numberContact.text = contact.number
                
                }
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for contact in (allContactList)!{
            
            if(contact.name == data?[indexPath.row]){
                let ligando = contact.number
                let url = URL(string: "tel://" + ligando)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        }
        
    }
    
    
}


