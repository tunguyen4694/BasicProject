//
//  ChartTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 19/07/2022.
//

import UIKit
import Charts

class ChartTBVC: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        createChart()
    }
    
    func createChart() {
        // Create bar chat
        let barChart = HorizontalBarChartView()
        
        // Configure the axis
//        let xAxis = barChart.xAxis
//        let rightAxis = barChart.rightAxis
        // Configure lengend
//        let legend = barChart.legend
        // Supply data
        var entries = [BarChartDataEntry]()
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 0...30)))
        }
        let set = ChartDataSet(entries: entries, label: "Cost")
        set.colors = ChartColorTemplates.pastel()
        let data = ChartData(dataSet: set)
        barChart.data = data
        
        self.addSubview(barChart)
        barChart.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 300)
        barChart.center = self.center
    }
}
