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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        chartBar.setExtraOffsets(left: 30, top: 30, right: 30, bottom: 30)
        chartBar.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)

        chartBar.noDataText = "No transaction data"
        chartBar.legend.enabled = false
//        chartBar.drawHoleEnabled = false
    }
    
    func setPieChart(_ totalExpense: Double, _ totalIncome: Double, chartView: PieChartView) {
        var entries = [PieChartDataEntry]()
        
        entries.append(PieChartDataEntry(value: totalExpense, label: "Expense"))
        entries.append(PieChartDataEntry(value: totalIncome, label: "Income"))
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.sliceSpace = 2
        set.selectionShift = 0
        let data = PieChartData(dataSet: set)
        chartView.data = data
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.groupingSeparator = "."
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.black)
    }
    
    func setCategoryPieChart(_ dictCategory: [String:Int], chartView: PieChartView) {
        var entries = [PieChartDataEntry]()
        
        var amountTotal = 0
        for (_, value) in dictCategory {
            amountTotal += value
        }
        
        for (key, value) in dictCategory {
            entries.append(PieChartDataEntry(value: Double(value*100/amountTotal), label: key))
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.sliceSpace = 2
        set.xValuePosition = .outsideSlice
        set.selectionShift = 0
        let data = PieChartData(dataSet: set)
        chartView.data = data
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.multiplier = 1.0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(.regular(ofSize: 12))
        data.setValueTextColor(.black)
    }

}
