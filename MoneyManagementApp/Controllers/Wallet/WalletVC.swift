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
    
    var categoryE: [String] = []
    var nameE: [String] = []
    var amountE: [Int] = []
    var nameI: [String] = []
    var amountI: [Int] = []
    
    var categoryNameCell: [String] = []
    var categoryAmountCell: [Int] = []
    
    var expenseDetailName: [String] = []
    var expenseDetailAmount: [Int] = []
    
    var incomeDetailName: [String] = []
    var incomeDetailAmount: [Int] = []
    
    var dictExpenseDetail: [String: Int] = [:]
    var dictIncomeDetail: [String: Int] = [:]
    var dictCategory: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        updateTransactionData(Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "loadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataMonth()
        addDataToArray()
    }
    
    @objc func refresh() {
       self.tableView.reloadData()
   }
}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return categoryNameCell.count
        } else if section == 7 {
            return expenseDetailName.count
        } else if section == 9 {
            return incomeDetailName.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.lblMonth.text = year
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
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
            cell.lblChartName.text = "Monthly Expense/Income In Year"
            cell.setCombinedChart(monthArr, expenseMonthArr, incomeMonthArr, cell.chartBar)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
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
            cell.setPieChart(Double(expenseAmount), Double(incomeAmount), chartView: cell.chartBar)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Category"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].category ?? "")
                }
            }
            let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
            cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = categoryNameCell[indexPath.row].prefix(1).uppercased() + categoryNameCell[indexPath.row].dropFirst()
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmountCell[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Expense"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
            cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = expenseDetailName[indexPath.row]
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: expenseDetailAmount[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Income"
            var categoryE: [String] = []
            var amountE: [Int] = []
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "+" {
                    amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    categoryE.append(transaction?[i].name ?? "")
                }
            }
            let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
            cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = incomeDetailName[indexPath.row]
            cell.lblAmount.text = "+" + ConvertHelper.share.stringFromNumber(currency: incomeDetailAmount[indexPath.row])
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
            let yearDisplay = Calendar.current.component(.year, from: Date())
            if year == "This year" {
                yearPicker.selectRow(yearArr.firstIndex(of: yearDisplay) ?? 0, inComponent: 0, animated: true)
            } else {
                yearPicker.selectRow(yearArr.firstIndex(of: Int(year) ?? yearDisplay) ?? 0, inComponent: 0, animated: true)
            }
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
    
    func updateTransactionData(_ date: Date) {
        beginningOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date)+1, month: 1, day: 1))
        
        transaction = DBManager.shareInstance.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        transactionMonth = []
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DBManager.shareInstance.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        getDataMonth()
        addDataToArray()
    }
    
    func getDataMonth() {
        var expenseAmount = 0
        var incomeAmount = 0
        expenseMonthArr = []
        incomeMonthArr = []
        for i in 0..<transactionMonth.count {
            expenseAmount = 0
            incomeAmount = 0
            for j in 0..<transactionMonth[i].count {
                if transactionMonth[i][j].stt == "-" {
                    expenseAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                } else {
                    incomeAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                }
            }
            expenseMonthArr.append(expenseAmount)
            incomeMonthArr.append(incomeAmount)
        }
        tableView.reloadData()
    }
    
    func addDataToArray() {
        categoryE = []
        nameE = []
        amountE = []
        nameI = []
        amountI = []
        categoryNameCell = []
        categoryAmountCell = []
        expenseDetailName = []
        expenseDetailAmount = []
        incomeDetailName = []
        incomeDetailAmount = []
        
        for i in 0..<(transaction?.count ?? 0) {
            if transaction?[i].stt == "-" {
                categoryE.append(transaction?[i].category ?? "")
                nameE.append(transaction?[i].name ?? "")
                amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            } else {
                nameI.append(transaction?[i].name ?? "")
                amountI.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            }
        }
        dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
        categoryNameCell = Array(dictCategory.keys)
        categoryAmountCell = Array(dictCategory.values)
        dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
        expenseDetailName = Array(dictExpenseDetail.keys)
        expenseDetailAmount = Array(dictExpenseDetail.values)
        dictIncomeDetail = ConvertHelper.share.convertToDict(name: nameI, amount: amountI)
        incomeDetailName = Array(dictIncomeDetail.keys)
        incomeDetailAmount = Array(dictIncomeDetail.values)
        
        tableView.reloadData()
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
        var date: Date = Date()
        if yearArr[row] != Calendar.current.component(.year, from: Date()) {
            year = String(yearArr[row])
            date = Calendar.current.date(from: DateComponents(year: yearArr[row])) ?? Date()
            updateTransactionData(date)
        } else {
            year = "This year"
            updateTransactionData(Date())
        }
        beginningOfYear = Calendar.current.date(from: DateComponents(year: yearArr[row], month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year:yearArr[row]+1, month: 1, day: 1))
        transaction = DBManager.shareInstance.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: yearArr[row], month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DBManager.shareInstance.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
}
