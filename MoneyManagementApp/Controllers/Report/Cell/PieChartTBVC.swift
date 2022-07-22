//
//  PieChartTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 22/07/2022.
//

import UIKit
import Charts

class PieChartTBVC: UITableViewCell {

    @IBOutlet weak var lblChartName: UILabel!
    @IBOutlet weak var chartBar: PieChartView!
    var entries = [ChartDataEntry()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        for i in 1...10 {
//            entries.append(ChartDataEntry(x: Double(1), y: Double(5)))
//        }
//
//        let set = PieChartDataSet(entries: entries)
//        set.colors = ChartColorTemplates.colorful()
//
//        let data = PieChartData(dataSet: set)
//        chartBar.data = data
//
        chartBar.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)

    }

}
