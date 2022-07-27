//
//  CategoryTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 14/07/2022.
//

import UIKit

class CategoryTBVC: UITableViewCell {

    @IBOutlet weak var vIcon: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        icon.tintColor = .white
        vIcon.layer.cornerRadius = 20
        vIcon.backgroundColor = .iconColor()
    }
}
