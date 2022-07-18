//
//  HistoryVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 18/07/2022.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var transaction: [Transaction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTBVC", bundle: nil), forCellReuseIdentifier: "MonthTBVC")
        tableView.register(UINib(nibName: "IncomeExpenseTBVC", bundle: nil), forCellReuseIdentifier: "IncomeExpenseTBVC")
        tableView.register(UINib(nibName: "TransactionTBVC", bundle: nil), forCellReuseIdentifier: "TransactionTBVC")
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
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
            return transaction.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as! IncomeExpenseTBVC
            cell.selectionStyle = .none
            cell.stvContent.layer.borderWidth = 0
            var total = 0
            for i in 0..<transaction.count {
                if transaction[i].stt == "-" {
                    total += (ConvertHelper.share.numberFromCurrencyString(string: transaction[i].amount!).intValue)
                    cell.lblExpense.text = ConvertHelper.share.stringFromNumber(currency: total)
                } else {
                    total += (ConvertHelper.share.numberFromCurrencyString(string: transaction[i].amount!).intValue)
                    cell.lblIncome.text = ConvertHelper.share.stringFromNumber(currency: total)
                }
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTBVC", for: indexPath) as! TransactionTBVC
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.imgIcon.image = transaction[indexPath.row].image
            cell.lblName.text = transaction[indexPath.row].name
            cell.lblDate.text = ConvertHelper.share.stringFromDate(date: transaction[indexPath.row].date ?? Date(), format: "dd MMM yyyy")
            cell.lblAmount.text = transaction[indexPath.row].stt?.appending(transaction[indexPath.row].amount ?? "")
            cell.lblAmount.textColor = transaction[indexPath.row].color
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTBVC", for: indexPath) as! MonthTBVC
            cell.selectionStyle = .none
            
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
}
