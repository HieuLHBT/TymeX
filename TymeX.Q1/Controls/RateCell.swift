//
//  RateCell.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import UIKit

//Tableview cell component
class RateCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtValue: UILabel!
    
    //Stored value
    var nameRate:String!
    var valueRate:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Selected event
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.nameRate = txtName.text
        self.valueRate = txtValue.text
    }
    
}
