//
//  contactCellTableView.swift
//  calling
//
//  Created by Ellen Coelho on 21/03/17.
//  Copyright © 2017 Ellen Coelho. All rights reserved.
//


import UIKit

class contactCellTableView: UITableViewCell {
  
    @IBOutlet weak var numberContact: UILabel!
    @IBOutlet weak var nameContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected")
        // Configure the view for the selected state
    }
    
}
