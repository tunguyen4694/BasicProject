//
//  AccountTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit

class AccountTBVC: UITableViewCell {
    
    @IBOutlet weak var lblElement: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
