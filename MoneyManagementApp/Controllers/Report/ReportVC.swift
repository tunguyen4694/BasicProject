//
//  ReportVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit
import RealmSwift
import Charts

class ReportVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var detail = [Report]()
    var transaction: Results<Transaction>?
    var nameE: [String] = []
    var amountE: [Int] = []
    var totalE = 0
    var totalI = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTBVC", bundle: nil), forCellReuseIdentifier: "MonthTBVC")
        tableView.register(UINib(nibName: "IncomeExpenseTBVC", bundle: nil), forCellReuseIdentifier: "IncomeExpenseTBVC")
        tableView.register(ChartTBVC.self, forCellReuseIdentifier: "ChartTBVC")
        tableView.register(UINib(nibName: "PieChartTBVC", bundle: nil), forCellReuseIdentifier: "PieChartTBVC")
        tableView.register(UINib(nibName: "HorizontalChartTBVC", bundle: nil), forCellReuseIdentifier: "HorizontalChartTBVC")
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
        getReportData()
    }

    func getReportData() {
        
        var amountInt = 0
        for i in 0..<(transaction?.count ?? 0) {
            if transaction?[i].stt == "-" {
                amountInt = ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue
                nameE.append(transaction?[i].name ?? "")
                amountE.append(amountInt)
                
                detail.append(Report(name: transaction?[i].name, amount: amountInt))
            }
        }
        print(detail)
    }
}

extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .separatorColor()
        return vSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
            cell.selectionStyle = .none
            cell.stvContent.layer.borderWidth = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    totalE += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                } else {
                    totalI += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                }
            }
            cell.lblExpense.text = ConvertHelper.share.stringFromNumber(currency: totalE)
            cell.lblIncome.text = ConvertHelper.share.stringFromNumber(currency: totalI)
            
            return cell
        case 2:
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "test")
//            cell.textLabel?.text = "Charts will update"
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTBVC", for: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalChartTBVC", for: indexPath) as! HorizontalChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Expense / Income"
            var entries = [PieChartDataEntry()]
            
            entries.append(PieChartDataEntry(value: Double(totalE), label: "Expense"))
            entries.append(PieChartDataEntry(value: Double(totalI), label: "Income"))
            let set = PieChartDataSet(entries: entries, label: "")
            set.colors = ChartColorTemplates.pastel()
            
            let data = PieChartData(dataSet: set)
            cell.chartBar.data = data
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "vi_VN")
            formatter.groupingSeparator = "."
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            
            cell.chartBar.legend.enabled = false
//            cell.chartBar.drawHoleEnabled = false
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Expenses"
            
            var entries = [PieChartDataEntry()]
            
            for i in 0..<nameE.count {
                entries.append(PieChartDataEntry(value: Double(amountE[i]), label: nameE[i]))
            }
            
            let set = PieChartDataSet(entries: entries, label: "")
            set.colors = ChartColorTemplates.pastel()
            set.yValuePosition = .outsideSlice
            set.xValuePosition = .outsideSlice
            set.sliceSpace = 2
            let data = PieChartData(dataSet: set)
            cell.chartBar.data = data
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "vi_VN")
            formatter.groupingSeparator = "."
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.setValueFont(.regular(ofSize: 12))
            data.setValueTextColor(.black)
            
            cell.chartBar.legend.enabled = false
//            cell.chartBar.drawHoleEnabled = false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 68
        case 2:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}
