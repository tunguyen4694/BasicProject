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
    var expenseMonthArr: [Int] = []
    var incomeMonthArr: [Int] = []
    
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
        yearPicker.backgroundColor = .white
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        getDataMonth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinedChartTBVC", for: indexPath) as! CombinedChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Monthly Expense/Income In Year"
            setCombinedChart(monthArr, expenseMonthArr, incomeMonthArr, cell.chartBar)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.selectionStyle = .none
            var expenseAmount = 0
            var incomeAmount = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                } else {
                    incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                }
            }
            cell.lblChartName.text = "Expense/Income"
            setPieChart(Double(expenseAmount), Double(incomeAmount), chartView: cell.chartBar)
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Category"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].category ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.selectionStyle = .none
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].category ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            let categoryName = Array(dictCategory.keys)
            let categoryAmount = Array(dictCategory.values)
            cell.lblName.text = categoryName[indexPath.row].prefix(1).uppercased() + categoryName[indexPath.row].dropFirst()
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmount[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Expense"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.selectionStyle = .none
            
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            let categoryName = Array(dictCategory.keys)
            let categoryAmount = Array(dictCategory.values)
            cell.lblName.text = categoryName[indexPath.row]
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmount[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.selectionStyle = .none
            cell.lblChartName.text = "Income"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "+" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.selectionStyle = .none
            
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "+" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = convertToDict(name: categoryE, amount: amountE)
            let categoryName = Array(dictCategory.keys)
            let categoryAmount = Array(dictCategory.values)
            cell.lblName.text = categoryName[indexPath.row]
            cell.lblAmount.text = "+" + ConvertHelper.share.stringFromNumber(currency: categoryAmount[indexPath.row])
            cell.lblAmount.textColor = .incomeColor()
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 68
        default:
            return UITableView.automaticDimension
        }
    }
}

extension WalletVC {
    @objc func onDoneButtonClick() {
        yearPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    func setCombinedChart(_ xValues: [String], _ yValuesLineChart: [Int], _ yValuesBarChart: [Int], _ chartView: CombinedChartView) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yValuesLine: [ChartDataEntry] = [ChartDataEntry]()
        var yValuesBar: [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yValuesLine.append(ChartDataEntry(x: Double(i), y: Double(yValuesLineChart[i])))
            yValuesBar.append(BarChartDataEntry(x: Double(i), y: Double(yValuesBarChart[i])))
        }
        
        let lineChartSet = LineChartDataSet(entries: yValuesLine, label: "Expense")
        lineChartSet.colors = [NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0)]
        lineChartSet.circleColors = [NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0)]
        lineChartSet.drawCirclesEnabled = true
        lineChartSet.circleRadius = 4
        lineChartSet.mode = .horizontalBezier
        lineChartSet.axisDependency = .left
        
        lineChartSet.lineWidth = 2
        let barChartSet = BarChartDataSet(entries: yValuesBar, label: "Income")
        barChartSet.colors = [NSUIColor(red: 149/255.0, green: 165/255.0, blue: 124/255.0, alpha: 1.0)]
        
        let data = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartSet)
        data.lineData = LineChartData(dataSet: lineChartSet)
        
        chartView.data = data
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.yOffset = -20
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthArr)
        chartView.xAxis.granularity = 1
        chartView.animate(xAxisDuration: 5, yAxisDuration: 5, easingOption: .easeOutBack)
//        chartView.xAxis.labelRotationAngle = -90
        chartView.xAxis.setLabelCount(monthArr.count, force: false)
        chartView.legend.enabled = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.groupingSeparator = "."
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.black)
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
        
        chartView.legend.enabled = false
    }
    
    func setCategoryPieChart(_ dictCategory: [String:Int], chartView: PieChartView) {
        var entries = [PieChartDataEntry]()
        
        for (key, value) in dictCategory {
            entries.append(PieChartDataEntry(value: Double(value), label: key))
        }
        
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
        data.setValueFont(.regular(ofSize: 12))
        data.setValueTextColor(.black)
        chartView.legend.enabled = false
    }
    
    func convertToDict(name: [String], amount: [Int]) -> [String: Int] {
        var result: [String: Int] = [:]
        for i in 0..<name.count {
            let total = result[name[i]] ?? 0
            result[name[i]] = total + amount[i]
        }
        return result
    }
    
    func getDataMonth() {
        var expenseAmount = 0
        var incomeAmount = 0
        for i in 0..<transactionMonth.count {
            for j in 0..<transactionMonth[i].count {
                if transactionMonth[i][j].stt == "-" {
                    expenseAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                } else {
                    incomeAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                }
            }
            expenseMonthArr.append(expenseAmount)
            incomeMonthArr.append(incomeAmount)
            expenseAmount = 0
            incomeAmount = 0
        }
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
