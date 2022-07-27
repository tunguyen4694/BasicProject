//
//  HistoryVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 18/07/2022.
//

import UIKit
import MonthYearPicker
import RealmSwift

class HistoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var month = "This month"
    var datePicker  = MonthYearPickerView(frame: .init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
    var toolBar: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - 300), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44)))
        tool.barStyle = .default
        tool.sizeToFit()
        
        return tool
    }()
    
    var transaction: Results<Transaction>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTransactionData(Date())
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTBVC", bundle: nil), forCellReuseIdentifier: "MonthTBVC")
        tableView.register(UINib(nibName: "IncomeExpenseTBVC", bundle: nil), forCellReuseIdentifier: "IncomeExpenseTBVC")
        tableView.register(UINib(nibName: "TransactionTBVC", bundle: nil), forCellReuseIdentifier: "TransactionTBVC")
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    func updateTransactionData(_ date: Date) {
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))
        let lastDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date)+1))
        
        transaction = DBManager.shareInstance.getMonthData(firstDayOfMonth ?? Date(), lastDayOfMonth ?? Date())
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            return transaction?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
            cell.stvContent.layer.borderWidth = 0
            var totalE = 0
            var totalI = 0
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
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTBVC", for: indexPath) as! TransactionTBVC
            cell.separatorInset = .zero
            cell.imgIcon.image = UIImage(systemName: transaction?[indexPath.row].image ?? "")
            cell.lblName.text = transaction?[indexPath.row].name
            cell.lblDate.text = ConvertHelper.share.stringFromDate(date: transaction?[indexPath.row].date ?? Date(), format: "dd MMM yyyy")
            cell.lblAmount.text = transaction?[indexPath.row].stt?.appending(transaction?[indexPath.row].amount ?? "")
            switch transaction?[indexPath.row].stt {
            case "-":
                cell.lblAmount.textColor = .expenseColor()
            default:
                cell.lblAmount.textColor = .incomeColor()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.lblMonth.text = month
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 68
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
                DBManager.shareInstance.deleteAnObject(self.transaction?[indexPath.row] ?? Transaction())
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
                let editVC = AddTransactionVC()
                editVC.transaction = self.transaction?[indexPath.row]
                editVC.passData = { [weak self] transaction in
                    guard let strongSelf = self, let transaction = transaction else { return }
                    DBManager.shareInstance.updateObject(strongSelf.transaction?[indexPath.row] ?? Transaction(), transaction)
                    strongSelf.tableView.reloadData()
                }
                self.present(editVC, animated: true)
            }
            
            let configure = UISwipeActionsConfiguration(actions: [delete, edit])
            return configure
        } else {
            return UISwipeActionsConfiguration()
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

extension HistoryVC {
    @objc func monthChanged(_ sender: MonthYearPickerView) {
        if Calendar.current.dateComponents([.month, .year], from: sender.date) != Calendar.current.dateComponents([.month, .year], from: Date()) {
            month = ConvertHelper.share.stringFromDate(date: sender.date, format: "MMM yyyy")
            updateTransactionData(sender.date)
        } else {
            month = "This month"
            updateTransactionData(Date())
        }
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
}
