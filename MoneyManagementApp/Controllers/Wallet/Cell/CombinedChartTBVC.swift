//
//  CombinedChartTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 26/07/2022.
//

import UIKit
import Charts

class CombinedChartTBVC: UITableViewCell {

    @IBOutlet weak var lblChartName: UILabel!
    @IBOutlet weak var chartBar: CombinedChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
