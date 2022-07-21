//
//  HomeVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var vBalance: UIView!
    @IBOutlet weak var lblTotalBalance: UILabel!
    
    // Header height constraint
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    // vSub height constraint
    @IBOutlet weak var subHeaderConstraint: NSLayoutConstraint!
    // vBalance height constraint
    @IBOutlet weak var balanceHeightConstraint: NSLayoutConstraint!
    // btnNoti Top constraint
    @IBOutlet weak var btnNotiTopConstraint: NSLayoutConstraint!
    // Header height trước và sau khi scroll
    let maxHeaderHeight: CGFloat = 169
    let minHeaderHeight: CGFloat = 44
    //vSub height trước và sau khi scroll
    let maxSubHeight: CGFloat = 128
    let minSubHeight: CGFloat = 44
    // vBalance height trước và sau khi scroll
    let maxBalanceHeight: CGFloat = 82
    let minBalanceHeight: CGFloat = 0
    // OffSet trước khi scroll
    var previousScrollOffSet: CGFloat = 0
    
    var transaction = DBManager.shareInstance.getData()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        welcomeUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightConstraint.constant = maxHeaderHeight
        balanceHeightConstraint.constant = maxBalanceHeight
        subHeaderConstraint.constant = maxSubHeight
        btnNotiTopConstraint.constant = 18
        updateHeader()
    }
    
    func setupUI() {
        vBalance.layer.cornerRadius = 10
        vBalance.layer.masksToBounds = false
        vBalance.layer.shadowColor = UIColor.black.cgColor
        vBalance.layer.shadowOpacity = 0.1
        vBalance.layer.shadowOffset = .init(width: 0, height: 2)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IncomeExpenseTBVC", bundle: nil), forCellReuseIdentifier: "IncomeExpenseTBVC")
        tableView.register(UINib(nibName: "AdsTBVC", bundle: nil), forCellReuseIdentifier: "AdsTBVC")
        tableView.register(UINib(nibName: "TransactionTBVC", bundle: nil), forCellReuseIdentifier: "TransactionTBVC")
    }
    
    func welcomeUser() {
        let hourStr = ConvertHelper.share.stringFromDate(date: Date(), format: "HH")
        guard let hourInt = Int(hourStr) else { return }
        
        switch hourInt {
        case 0..<6:
            lblHello.text = "Good night,"
        case 6..<12:
            lblHello.text = "Good morning,"
        case 12..<18:
            lblHello.text = "Good afternoon,"
        case 18..<24:
            lblHello.text = "Good evening,"
        default:
            lblHello.text = "Welcome,"
        }
        
        guard let user = Auth.auth().currentUser else { return }
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    lblUserName.text = user.displayName
                default:
                    lblUserName.text = user.email
                }
            }
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // Custom view in header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .clear
        
        let lblTitleHeader = UILabel(frame: .init(x: 24, y: 0, width: 100, height: 40))
        headerView.addSubview(lblTitleHeader)
        lblTitleHeader.center.y = headerView.center.y
        lblTitleHeader.font = .bold(ofSize: 16)
        lblTitleHeader.textColor = .black
        
        let btnHeader = UIButton(frame: .init(x: headerView.frame.maxX-124, y: 0, width: 100, height: 40))
        headerView.addSubview(btnHeader)
        btnHeader.center.y = lblTitleHeader.center.y
        btnHeader.setTitleColor(.mainColor(), for: .normal)
        btnHeader.titleLabel?.font = .semibold(ofSize: 14)
        btnHeader.contentHorizontalAlignment = .right
        
        if section == 2 {
            lblTitleHeader.text = "History"
            btnHeader.setTitle("See all", for: .normal)
            btnHeader.addTarget(self, action: #selector(onHistory(_:)), for: .touchUpInside)
            return headerView
        } else if section == 0 {
            lblTitleHeader.text = "This month"
            btnHeader.setTitle("View report", for: .normal)
            return headerView
        } else {
            return nil
        }
    }
    
    @objc func onHistory(_ sender: UIButton) {
        let vc = HistoryVC()
        vc.transaction = transaction
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return transaction.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as? IncomeExpenseTBVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            var totalE: Int = 0
            var totalI: Int = 0
            
            for i in 0..<transaction.count {
                switch transaction[i].stt {
                case "-":
                    totalE += (ConvertHelper.share.numberFromCurrencyString(string: transaction[i].amount!).intValue)
                default:
                    totalI += (ConvertHelper.share.numberFromCurrencyString(string: transaction[i].amount!).intValue)
                }
            }
            
            cell.lblExpense.text = ConvertHelper.share.stringFromNumber(currency: totalE)
            
            cell.lblIncome.text = ConvertHelper.share.stringFromNumber(currency: totalI)
            
            lblTotalBalance.text = ConvertHelper.share.stringFromNumber(currency: totalI - totalE)
            
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdsTBVC", for: indexPath) as? AdsTBVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTBVC", for: indexPath) as? TransactionTBVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.imgIcon.image = UIImage(systemName: transaction[indexPath.row].image ?? "") 
            cell.lblName.text = transaction[indexPath.row].name
            cell.lblDate.text = ConvertHelper.share.stringFromDate(date: transaction[indexPath.row].date ?? Date(), format: "dd/MM/yyyy")
            
            let stt = transaction[indexPath.row].stt ?? ""
            let amount = transaction[indexPath.row].amount ?? ""
            let a = stt.appending(amount)
            
            cell.lblAmount.text = a
//            cell.lblAmount.textColor = transaction[indexPath.row].color
            switch transaction[indexPath.row].stt {
            case "-":
                cell.lblAmount.textColor = .expenseColor()
            default:
                cell.lblAmount.textColor = .incomeColor()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 68
        } else if indexPath.section == 1 {
            return 139
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
//                self.transaction.remove(at: indexPath.row)
                DBManager.shareInstance.deleteAnObject(self.transaction[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
                let editVC = AddTransactionVC()
                editVC.transaction = self.transaction[indexPath.row]
                editVC.passData = { [weak self] transaction in
                    guard let strongSelf = self, let transaction = transaction else { return }
//                    strongSelf.transaction[indexPath.row] = transaction
//                    strongSelf.transaction.sort(by: { $1.date ?? Date() < $0.date ?? Date() })
                    DBManager.shareInstance.updateObject(strongSelf.transaction[indexPath.row], transaction)
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
    
    // Animate header when scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffSet
        
        let absoluteTop: CGFloat = 0.0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        guard canAnimateHeader(scrollView) else { return }
        
        var newHeaderHeight = headerHeightConstraint.constant
        var newSubHeaderHeight = subHeaderConstraint.constant
        var newBalanceHeight = balanceHeightConstraint.constant
        var newBtnNotiTopConstraint = btnNotiTopConstraint.constant
        
        if isScrollingDown {
            newHeaderHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
            newSubHeaderHeight = max(minSubHeight, subHeaderConstraint.constant - abs(scrollDiff))
            newBalanceHeight = max(minBalanceHeight, balanceHeightConstraint.constant - abs(scrollDiff))
            newBtnNotiTopConstraint = max(6, btnNotiTopConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeaderHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
            newSubHeaderHeight = min(maxSubHeight, subHeaderConstraint.constant + abs(scrollDiff))
            newBalanceHeight = min(maxBalanceHeight, balanceHeightConstraint.constant + abs(scrollDiff))
            newBtnNotiTopConstraint = min(18, btnNotiTopConstraint.constant + abs(scrollDiff))
        }
        
        // Tính theo view có height contraint thay đổi lớn nhất trong 2 view
        if newHeaderHeight != headerHeightConstraint.constant
        {
            headerHeightConstraint.constant = newHeaderHeight
            subHeaderConstraint.constant = newSubHeaderHeight
            balanceHeightConstraint.constant = newBalanceHeight
            btnNotiTopConstraint.constant = newBtnNotiTopConstraint
            updateHeader()
            setScrollPosition(previousScrollOffSet)
        }
        previousScrollOffSet = scrollView.contentOffset.y
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
}

// Animate header when scroll
extension HomeVC {
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Tính theo height constraint của view nhỏ nhât trong 2 view thay đổi height constraint
        let scrollMaxViewHeight = scrollView.frame.height + balanceHeightConstraint.constant - minBalanceHeight
        return scrollView.contentSize.height > scrollMaxViewHeight
    }
    
    func setScrollPosition(_ position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }
    
    func scrollViewDidStopScrolling() {
        // Tính theo height constraint của view nhỏ nhất trong 2 view thay đổi height constraint
        let range = maxBalanceHeight - minBalanceHeight
        let midPoint = minBalanceHeight + range/2
        
        if balanceHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    // Thu vào
    func collapseHeader() {
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.subHeaderConstraint.constant = self.minSubHeight
            self.balanceHeightConstraint.constant = self.minBalanceHeight
            self.btnNotiTopConstraint.constant = 6
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    // Kéo ra
    func expandHeader() {
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.subHeaderConstraint.constant = self.maxSubHeight
            self.balanceHeightConstraint.constant = self.maxBalanceHeight
            self.btnNotiTopConstraint.constant = 18
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func updateHeader() {
        // Tính theo height constraint của view nhỏ nhất trong 2 view thay đổi height constraint
        let range = maxBalanceHeight - minBalanceHeight
        let openAmount = balanceHeightConstraint.constant - minBalanceHeight
        let percentage = openAmount/range
        vBalance.alpha = percentage
        lblHello.alpha = percentage
        lblUserName.alpha = percentage
    }
}
