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
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        vBalance.layer.cornerRadius = 10
        vBalance.layer.masksToBounds = false
        vBalance.layer.shadowColor = UIColor.black.cgColor
        vBalance.layer.shadowOpacity = 0.1
        vBalance.layer.shadowOffset = .init(width: 0, height: 2)
        
        tableView.separatorStyle = .none
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
//            let title = "This month"
            return "This month"
        } else if section == 2 {
            return "History"
        } else {
          return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 10
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .black
    }
}
