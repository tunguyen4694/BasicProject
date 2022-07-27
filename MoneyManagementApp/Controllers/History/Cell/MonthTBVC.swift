//
//  MonthTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 18/07/2022.
//

import UIKit

class MonthTBVC: UITableViewCell {

    @IBOutlet weak var lblMonth: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
