//
//  HomeVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit

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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
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
        // Disable cố định header khi scroll tableView
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "This month"
        } else if section == 2 {
            return "History"
        } else {
          return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 20
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseTBVC", for: indexPath) as? IncomeExpenseTBVC else { return UITableViewCell() }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdsTBVC", for: indexPath) as? AdsTBVC else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTBVC", for: indexPath) as? TransactionTBVC else { return UITableViewCell() }
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
    
    // Set header text color
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .black
    }
    
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
        
        if isScrollingDown {
            newHeaderHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
            newSubHeaderHeight = max(minSubHeight, subHeaderConstraint.constant - abs(scrollDiff))
            newBalanceHeight = max(minBalanceHeight, balanceHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeaderHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
            newSubHeaderHeight = min(maxSubHeight, subHeaderConstraint.constant + abs(scrollDiff))
            newBalanceHeight = min(maxBalanceHeight, balanceHeightConstraint.constant + abs(scrollDiff))
        }
        
        // Tính theo view có height contraint thay đổi lớn nhất trong 2 view
        if newHeaderHeight != headerHeightConstraint.constant
        {
            headerHeightConstraint.constant = newHeaderHeight
            subHeaderConstraint.constant = newSubHeaderHeight
            balanceHeightConstraint.constant = newBalanceHeight
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
        view.layoutIfNeeded()
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
        view.layoutIfNeeded()
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
