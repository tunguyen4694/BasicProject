//
//  ReportVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit
import RealmSwift
import Charts
import MonthYearPicker

class ReportVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var transaction: Results<Transaction>?
    var categoryE: [String] = []
    var nameE: [String] = []
    var amountE: [Int] = []
    var nameI: [String] = []
    var amountI: [Int] = []
    var totalE = 0
    var totalI = 0
    var dictExpenseDetail: [String: Int] = [:]
    var dictIncomeDetail: [String: Int] = [:]
    var dictCategory: [String: Int] = [:]
    
    var categoryNameCell: [String] = []
    var categoryAmountCell: [Int] = []
    
    var expenseDetailName: [String] = []
    var expenseDetailAmount: [Int] = []
    
    var incomeDetailName: [String] = []
    var incomeDetailAmount: [Int] = []
    
    var month = "This month"
    var datePicker  = MonthYearPickerView(frame: .init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
    var toolBar: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - 300), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44)))
        tool.barStyle = .default
        tool.sizeToFit()
        
        return tool
    }()
    
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
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
        updateTransactionData(Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "loadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        getReportData()
    }
    
    @objc func refresh() {
       self.tableView.reloadData()
   }
}

extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
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
        if section == 4 {
            return categoryNameCell.count
        } else if section == 6 {
            return expenseDetailName.count
        } else if section == 8 {
            return incomeDetailName.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.lblMonth.text = month
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
            cell.stvContent.layer.borderWidth = 0
            var expenseAmount = 0
            var incomeAmount = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    totalE = expenseAmount
                } else {
                    incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    totalI = incomeAmount
                }
            }
            cell.lblExpense.text = ConvertHelper.share.stringFromNumber(currency: totalE)
            cell.lblIncome.text = ConvertHelper.share.stringFromNumber(currency: totalI)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Expense / Income"
            cell.setPieChart(Double(totalE), Double(totalI), chartView: cell.chartBar)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Caterogy"
            dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
            cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = categoryNameCell[indexPath.row].prefix(1).uppercased() + categoryNameCell[indexPath.row].dropFirst()
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmountCell[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Expenses"
            dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
            cell.setCategoryPieChart(dictExpenseDetail, chartView: cell.chartBar)
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = expenseDetailName[indexPath.row]
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: expenseDetailAmount[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTBVC", for: indexPath) as! PieChartTBVC
            cell.lblChartName.text = "Incomes"
            cell.setCategoryPieChart(dictIncomeDetail, chartView: cell.chartBar)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVC", for: indexPath) as! ReportTBVC
            cell.lblName.text = incomeDetailName[indexPath.row]
            cell.lblAmount.text = "+" + ConvertHelper.share.stringFromNumber(currency: incomeDetailAmount[indexPath.row])
            cell.lblAmount.textColor = .incomeColor()
            return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            datePicker.backgroundColor = .white
            datePicker.addTarget(self, action: #selector(self.monthChanged(_:)), for: .valueChanged)
            
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            
            view.addSubview(datePicker)
            view.addSubview(toolBar)
        }
    }
}

extension ReportVC {
    @objc func monthChanged(_ sender: MonthYearPickerView) {
        if Calendar.current.dateComponents([.month, .year], from: sender.date) != Calendar.current.dateComponents([.month, .year], from: Date()) {
            month = ConvertHelper.share.stringFromDate(date: sender.date, format: "MMM yyyy")
            updateTransactionData(sender.date)
        } else {
            month = "This month"
            updateTransactionData(Date())
        }
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    func updateTransactionData(_ date: Date) {
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))
        let lastDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date)+1))
        
        transaction = DBManager.shareInstance.getMonthData(firstDayOfMonth ?? Date(), lastDayOfMonth ?? Date())
        getReportData()
    }
    
    func getReportData() {
        categoryE = []
        nameE = []
        amountE = []
        nameI = []
        amountI = []
        totalE = 0
        totalI = 0
        categoryNameCell = []
        categoryAmountCell = []
        
        expenseDetailName = []
        expenseDetailAmount = []
        
        incomeDetailName = []
        incomeDetailAmount = []
        
        for i in 0..<(transaction?.count ?? 0) {
            if transaction?[i].stt == "-" {
                nameE.append(transaction?[i].name ?? "")
                amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                categoryE.append(transaction?[i].category ?? "")
            } else {
                nameI.append(transaction?[i].name ?? "")
                amountI.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            }
        }
        dictIncomeDetail = ConvertHelper.share.convertToDict(name: nameI, amount: amountI)
        incomeDetailName = Array(dictIncomeDetail.keys)
        incomeDetailAmount = Array(dictIncomeDetail.values)
        dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
        for (key, value) in dictExpenseDetail {
            expenseDetailName.append(key)
            expenseDetailAmount.append(value)
        }
        dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
        for (key, value) in dictCategory {
            categoryNameCell.append(key)
            categoryAmountCell.append(value)
        }
    }
}
