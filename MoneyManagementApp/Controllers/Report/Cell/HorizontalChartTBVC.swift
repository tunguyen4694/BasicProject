//
//  HorizontalChartTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 22/07/2022.
//

import UIKit
import Charts

class HorizontalChartTBVC: UITableViewCell {

    @IBOutlet weak var chartBar: HorizontalBarChartView!
    var entries = [BarChartDataEntry()]
    
    override func awakeFromNib() {
        super.awakeFromNib()

        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 0...30)))
        }
        let set = BarChartDataSet(entries: entries, label: "Cost")
        set.colors = ChartColorTemplates.pastel()
        let data = BarChartData(dataSet: set)
        chartBar.data = data
        
        chartBar.animate(yAxisDuration: 2.5)
    }

}
