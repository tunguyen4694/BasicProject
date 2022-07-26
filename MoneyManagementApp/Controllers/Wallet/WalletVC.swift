//
//  WalletVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit
import Charts
import RealmSwift

class WalletVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var yearPicker = UIPickerView(frame: .init(x: 0, y: UIScreen.main.bounds.size.height-300, width: UIScreen.main
        .bounds.size.width, height: 300))
    var toolBar = UIToolbar(frame: .init(x: 0, y: UIScreen.main.bounds.size.height-300, width: UIScreen.main.bounds.size.width, height: 44))
    var yearArr: [Int] = {
        var year: [Int] = []
        for i in (2000...2030).reversed() {
            year.append(i)
        }
        return year
    }()
    var monthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var transaction: Results<Transaction>?
    var transactionMonth: [Results<Transaction>] = []
    var beginningOfYear: Date?
    var endOfYear: Date?
    var beginningOfMonth: Date?
    var endOfMonth: Date?
    var year = "This year"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginningOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date())+1, month: 1, day: 1))
        
        transaction = DBManager.shareInstance.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DBManager.shareInstance.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTBVC", bundle: nil), forCellReuseIdentifier: "MonthTBVC")
        tableView.register(UINib(nibName: "IncomeExpenseTBVC", bundle: nil), forCellReuseIdentifier: "IncomeExpenseTBVC")
        tableView.register(UINib(nibName: "PieChartTBVC", bundle: nil), forCellReuseIdentifier: "PieChartTBVC")
        tableView.register(UINib(nibName: "ReportTBVC", bundle: nil), forCellReuseIdentifier: "ReportTBVC")
        tableView.register(UINib(nibName: "CombinedChartTBVC", bundle: nil), forCellReuseIdentifier: "CombinedChartTBVC")
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
        yearPicker.delegate = self
        yearPicker.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.selectionStyle = .none
            cell.lblMonth.text = year
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
            cell.selectionStyle = .none
            cell.stvContent.layer.borderWidth = 0
            var expenseAmount = 0
            var incomeAmount = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                } else {
                    incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                }
            }
            cell.lblExpense.text = ConvertHelper.share.stringFromNumber(currency: expenseAmount)
            cell.lblIncome.text = ConvertHelper.share.stringFromNumber(currency: incomeAmount)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinedChartTBVC", for: indexPath) as! CombinedChartTBVC
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .separatorColor()
        return vSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            toolBar.barStyle = .default
            toolBar.sizeToFit()
            toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))], animated: true)
            let year = Calendar.current.component(.year, from: Date())
            yearPicker.selectRow(yearArr.firstIndex(of: year) ?? 0, inComponent: 0, animated: true)
            view.addSubview(yearPicker)
            view.addSubview(toolBar)
        }
    }
}

extension WalletVC {
    @objc func onDoneButtonClick() {
        yearPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    func setChart(_ xValues: [String], _ yValuesLineChart: [Int], _ yValuesBarChart: [Int], _ chartView: CombinedChartView) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yValuesLine: [ChartDataEntry] = [ChartDataEntry]()
        var yValuesBar: [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yValuesLine.append(ChartDataEntry(x: Double(i), y: Double(yValuesLineChart[i])))
            yValuesBar.append(BarChartDataEntry(x: Double(i), y: Double(yValuesBarChart[i])))
        }
        
        let lineChartSet = LineChartDataSet(entries: yValuesLine, label: "Expense")
        let barChartSet = BarChartDataSet(entries: yValuesBar, label: "Income")
        
        let data = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartSet)
        data.lineData = LineChartData(dataSet: lineChartSet)
        
        chartView.data = data
    }
}

extension WalletVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearArr[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if yearArr[row] != Calendar.current.component(.year, from: Date()) {
        year = String(yearArr[row])
        } else {
            year = "This year"
        }
        beginningOfYear = Calendar.current.date(from: DateComponents(year: yearArr[row], month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year:yearArr[row]+1, month: 1, day: 1))
        transaction = DBManager.shareInstance.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: yearArr[row], month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DBManager.shareInstance.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        print(transactionMonth)
        
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
}
