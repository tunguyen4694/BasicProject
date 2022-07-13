//
//  IncomeExpenseTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 13/07/2022.
//

import UIKit

class IncomeExpenseTBVC: UITableViewCell {

    @IBOutlet weak var stvContent: UIStackView!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stvContent.clipsToBounds = true
        stvContent.layer.cornerRadius = 10
        stvContent.layer.borderWidth = 1
        stvContent.layer.borderColor = UIColor.separatorColor().cgColor
        
        lblIncome.textColor = .incomeColor()
        lblIncome.font = .semibold(ofSize: 18)
        lblExpense.textColor = .expenseColor()
        lblExpense.font = .semibold(ofSize: 18)
    }
}
